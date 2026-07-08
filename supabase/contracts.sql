create extension if not exists pgcrypto;

create table if not exists public.contracts (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  customer_name text not null,
  recipient_name text not null,
  recipient_address text not null,
  contract_number text not null unique,
  subject text not null,
  project_title text not null,
  city text not null default 'Surabaya',
  status text not null default 'Draft',
  contract_date date not null,
  total_amount numeric(14, 2) not null default 0,
  intro_message text,
  material_details text,
  closing_notes text,
  sections jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.contracts enable row level security;

drop policy if exists "public can read contracts" on public.contracts;
create policy "public can read contracts"
on public.contracts
for select
to anon, authenticated
using (true);

drop policy if exists "public can insert contracts" on public.contracts;
create policy "public can insert contracts"
on public.contracts
for insert
to anon, authenticated
with check (true);
