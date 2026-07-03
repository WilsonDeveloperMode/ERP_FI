create extension if not exists pgcrypto;

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  contact_number text not null,
  email text,
  status text not null default 'Active',
  addresses text[] not null,
  contact_person text,
  customer_type text not null default 'Residential',
  notes text,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.customers enable row level security;

drop policy if exists "public can read customers" on public.customers;
create policy "public can read customers"
on public.customers
for select
to anon, authenticated
using (true);

drop policy if exists "public can insert customers" on public.customers;
create policy "public can insert customers"
on public.customers
for insert
to anon, authenticated
with check (true);

drop policy if exists "public can update customers" on public.customers;
create policy "public can update customers"
on public.customers
for update
to anon, authenticated
using (true)
with check (true);
