-- Ma'ak — Supabase schema
-- Run this in the Supabase SQL editor after creating your project.

-- 1) Base profile row per auth user, holding the chosen role.
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  role text check (role in ('help_seeker', 'volunteer')),
  full_name text,
  created_at timestamptz default now()
);

-- 2) Help Seeker registration details.
create table if not exists public.help_seeker_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  chronic_condition text not null,
  preferred_language text not null,
  description text,
  created_at timestamptz default now()
);

-- 3) Volunteer registration details.
create table if not exists public.volunteer_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  condition_experience text not null,
  preferred_language text not null,
  experience_description text not null,
  verification_document_url text,
  status text default 'pending_review'
    check (status in ('pending_review', 'approved', 'rejected')),
  created_at timestamptz default now()
);

-- 4) Storage bucket for volunteer verification documents.
insert into storage.buckets (id, name, public)
values ('verification-documents', 'verification-documents', true)
on conflict (id) do nothing;

-- 5) Row Level Security: users can only read/write their own rows.
alter table public.profiles enable row level security;
alter table public.help_seeker_profiles enable row level security;
alter table public.volunteer_profiles enable row level security;

drop policy if exists "profiles: owner read/write" on public.profiles;
create policy "profiles: owner read/write"
  on public.profiles for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "help_seeker_profiles: owner read/write" on public.help_seeker_profiles;
create policy "help_seeker_profiles: owner read/write"
  on public.help_seeker_profiles for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "volunteer_profiles: owner read/write" on public.volunteer_profiles;
create policy "volunteer_profiles: owner read/write"
  on public.volunteer_profiles for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 6) Storage policy: users can upload/view their own verification docs.
drop policy if exists "verification-documents: owner upload" on storage.objects;
create policy "verification-documents: owner upload"
  on storage.objects for insert
  with check (
    bucket_id = 'verification-documents'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

drop policy if exists "verification-documents: public read" on storage.objects;
create policy "verification-documents: public read"
  on storage.objects for select
  using (bucket_id = 'verification-documents');

-- 7) Admin support — run this part after the admin feature was added.
-- Allow 'admin' as a third possible role value.
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles
  add constraint profiles_role_check check (role in ('help_seeker', 'volunteer', 'admin'));

-- Column the admin fills in when rejecting a volunteer application.
alter table public.volunteer_profiles add column if not exists rejection_reason text;

-- Let any user whose own profile role is 'admin' read and update every
-- volunteer application (not just their own). The owner policy above still
-- covers normal volunteers reading/writing their own row.
drop policy if exists "volunteer_profiles: admin read/write" on public.volunteer_profiles;
create policy "volunteer_profiles: admin read/write"
  on public.volunteer_profiles for all
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid() and profiles.role = 'admin'
    )
  );
