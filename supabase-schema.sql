-- Room Inventory v2 — Supabase table schema
-- Run this in the Supabase SQL Editor (project → SQL Editor → New query)

create table if not exists inventory (
  id              bigint primary key,
  name            text not null default '',
  sn              text default '',
  category        text default '',
  location        text default '',
  doc_type        text default '',
  digital_copy    boolean default false,
  fill_level      text default '',
  qty             text default '1',
  frequency       text default '',
  criticality     text default '',
  replaceability  text default '',
  condition       text default '',
  keep            text default '',
  year_purchased  text default '',
  last_used       text default '',
  est_value       text default '',
  notes           text default '',
  misplaced       boolean default false,
  last_modified   timestamptz default now()
);

-- Enable Row Level Security but allow all access via anon key
-- (this is a single-user personal app — adjust if you ever share access)
alter table inventory enable row level security;

create policy "Allow all for anon" on inventory
  for all using (true) with check (true);

-- Index for faster location-based queries (useful in v3+)
create index if not exists idx_inventory_location on inventory(location);
create index if not exists idx_inventory_category on inventory(category);
