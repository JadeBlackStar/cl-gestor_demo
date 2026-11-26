-- Ejecuta este script en Supabase > SQL Editor
create table if not exists public.cl_gestor_datos (
  usuario_id uuid primary key references auth.users(id) on delete cascade,
  datos jsonb not null default '{}'::jsonb,
  actualizado_en timestamptz not null default now()
);

alter table public.cl_gestor_datos enable row level security;

-- Cada usuario solo puede leer, insertar o modificar su propia fila.
drop policy if exists "Cada usuario accede a sus propios datos" on public.cl_gestor_datos;
create policy "Cada usuario accede a sus propios datos"
on public.cl_gestor_datos
for all
using (auth.uid() = usuario_id)
with check (auth.uid() = usuario_id);

-- Realtime para sincronización entre dispositivos.
alter publication supabase_realtime add table public.cl_gestor_datos;
