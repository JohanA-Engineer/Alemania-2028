-- Ejecute este archivo si ya había ejecutado schema.sql anteriormente.
create table if not exists public.trackers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  slug text not null check (slug in ('savings', 'debt', 'ecommerce')),
  title text not null check (char_length(title) between 1 and 100),
  kind text not null check (kind in ('savings', 'debt', 'ecommerce')),
  current_value numeric(14,2) not null default 0 check (current_value >= 0),
  target_value numeric(14,2) not null default 0 check (target_value >= 0),
  progress integer not null default 0 check (progress between 0 and 100),
  notes text not null default '' check (char_length(notes) <= 500),
  updated_at timestamptz not null default now(),
  unique (user_id, slug)
);
alter table public.trackers enable row level security;
grant select, insert, update, delete on table public.trackers to authenticated;
create policy "Users manage only their trackers" on public.trackers for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
alter publication supabase_realtime add table public.trackers;
