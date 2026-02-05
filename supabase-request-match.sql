-- 재매칭 시 남은 데이터 충돌 방지: 매번 호출 시 해당 세션을 무조건 waiting으로 초기화(이전 matched/partner 초기화). Supabase SQL Editor에서 이 전체를 실행하세요.
create or replace function public.request_match(
  p_session_id text,
  p_model text,
  p_side text,
  p_condition text default 'A',
  p_usage_months int default 0
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $b$
declare
  v_need_side text;
  v_partner record;
  v_my_id uuid;
  v_payload jsonb;
  v_game_id uuid;
  v_existing record;
begin
  v_need_side := case when p_side = 'left' then 'right' else 'left' end;
  insert into match_queue (session_id, model, side, condition, usage_months, status)
  values (p_session_id, p_model, p_side, p_condition, p_usage_months, 'waiting')
  on conflict (session_id) do update set
    model = excluded.model,
    side = excluded.side,
    condition = excluded.condition,
    usage_months = excluded.usage_months,
    status = 'waiting',
    partner_session_id = null,
    partner_model = null,
    partner_side = null,
    partner_condition = null,
    game_id = null,
    created_at = now()
  returning id into v_my_id;
  select status, side, model, condition, partner_model, partner_side, partner_condition, game_id
  into v_existing
  from match_queue where id = v_my_id limit 1;
  if v_existing.status = 'matched' then
    return jsonb_build_object('matched', true, 'payload', jsonb_build_object('mySide', v_existing.side, 'model', v_existing.model, 'condition', v_existing.condition, 'oppModel', v_existing.partner_model, 'oppSide', v_existing.partner_side, 'oppCondition', v_existing.partner_condition, 'game_id', v_existing.game_id));
  end if;
  select id, session_id, model, side, condition, usage_months
  into v_partner
  from (
    select *,
      (abs(usage_months - p_usage_months) * 2 +
       abs(case match_queue.condition when 'S' then 1 when 'A' then 2 when 'B' then 3 else 2 end -
           case p_condition when 'S' then 1 when 'A' then 2 when 'B' then 3 else 2 end) * 5
      as score
    from match_queue
    where model = p_model and side = v_need_side and status = 'waiting' and session_id != p_session_id
    for update skip locked
  ) scored
  order by score, created_at
  limit 1;
  if v_partner.id is not null then
    v_game_id := gen_random_uuid();
    insert into public.games (id, current_round, updated_at) values (v_game_id, 1, now()) on conflict (id) do update set updated_at = now();
    update match_queue set
      status = 'matched',
      partner_session_id = v_partner.session_id,
      partner_model = v_partner.model,
      partner_side = v_partner.side,
      partner_condition = v_partner.condition,
      game_id = v_game_id
    where id = v_my_id;
    update match_queue set
      status = 'matched',
      partner_session_id = p_session_id,
      partner_model = p_model,
      partner_side = p_side,
      partner_condition = p_condition,
      game_id = v_game_id
    where id = v_partner.id;
    v_payload := jsonb_build_object('matched', true, 'payload', jsonb_build_object('mySide', p_side, 'model', p_model, 'condition', p_condition, 'oppModel', v_partner.model, 'oppSide', v_partner.side, 'oppCondition', v_partner.condition, 'game_id', v_game_id));
    return v_payload;
  end if;
  return jsonb_build_object('matched', false, 'waiting', true);
end;
$b$;

-- 라운드 진행은 RPC로만 (한쪽만 다음 스텝 안 넘어가는 문제 방지). 기존 game_id에 행 없으면 여기서 생성.
create or replace function public.set_game_round(p_game_id uuid, p_round int)
returns void
language plpgsql
security definer
set search_path = public
as $b$
declare
  v_round int := greatest(1, least(5, p_round));
begin
  insert into games (id, current_round, updated_at) values (p_game_id, v_round, now())
  on conflict (id) do update set current_round = v_round, updated_at = now();
end;
$b$;

-- 대기 중인 쪽은 이 함수만 호출 (쓰기 없음 → 덮어쓰기 불가). Supabase SQL Editor에서 실행.
create or replace function public.get_my_match_status(p_session_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $b$
declare
  v_row record;
begin
  select status, side, model, condition, partner_model, partner_side, partner_condition, game_id
  into v_row
  from match_queue
  where session_id = p_session_id
  limit 1;
  if not found then
    return jsonb_build_object('matched', false);
  end if;
  if v_row.status = 'matched' then
    return jsonb_build_object('matched', true, 'payload', jsonb_build_object('mySide', v_row.side, 'model', v_row.model, 'condition', v_row.condition, 'oppModel', v_row.partner_model, 'oppSide', v_row.partner_side, 'oppCondition', v_row.partner_condition, 'game_id', v_row.game_id));
  end if;
  return jsonb_build_object('matched', false, 'waiting', true);
end;
$b$;

-- anon(비로그인) 클라이언트가 RPC 호출할 수 있도록 권한 부여 (한쪽만 매칭될 때 RPC 미호출 원인 방지)
grant execute on function public.request_match(text, text, text, text, int) to anon;
grant execute on function public.get_my_match_status(text) to anon;
grant execute on function public.set_game_round(uuid, int) to anon;
