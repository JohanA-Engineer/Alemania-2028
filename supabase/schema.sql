-- Ejecute este archivo una vez en Supabase: SQL Editor > New query.
create table if not exists public.tasks (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  tarea text not null check (char_length(tarea) between 1 and 160),
  area text not null,
  estado text not null check (estado in ('Sin empezar','En progreso','Listo')),
  fecha date,
  notas text not null default '',
  created_at timestamptz not null default now()
);
alter table public.tasks enable row level security;
-- Permisos explícitos: necesarios si "Automatically expose new tables" está desactivado.
grant select, insert, update, delete on table public.tasks to authenticated;
create policy "Users manage only their tasks" on public.tasks for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
alter publication supabase_realtime add table public.tasks;
