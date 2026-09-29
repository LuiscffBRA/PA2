-- ==============================================================================
-- SCHEMA DO BANCO DE DADOS - PA2 / PEGA BODE (SUPABASE POSTGRESQL)
-- ==============================================================================

-- 1. TABELA DE PERFIS DE USUÁRIOS (Clientes e Vendedores)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  email text not null,
  user_type text not null check (user_type in ('client', 'vendor')),
  phone text,
  trade_name text,
  bio text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Habilita Row Level Security (RLS)
alter table public.profiles enable row level security;

-- Políticas de acesso para Profiles
drop policy if exists "Perfis são visíveis para qualquer usuário autenticado" on public.profiles;
create policy "Perfis são visíveis para qualquer usuário autenticado"
  on public.profiles for select
  to authenticated
  using (true);

drop policy if exists "Usuários podem atualizar apenas seu próprio perfil" on public.profiles;
create policy "Usuários podem atualizar apenas seu próprio perfil"
  on public.profiles for update
  to authenticated
  using (auth.uid() = id);

drop policy if exists "Usuários podem criar seu próprio perfil" on public.profiles;
create policy "Usuários podem criar seu próprio perfil"
  on public.profiles for insert
  to authenticated
  with check (auth.uid() = id);


-- 2. TABELA DE POSTAGENS / PRODUTOS DO FEED
create table if not exists public.posts (
  id uuid default gen_random_uuid() primary key,
  vendor_id uuid references public.profiles(id) on delete cascade not null,
  vendor_name text,
  vendor_trade_name text,
  vendor_phone text,
  title text not null,
  description text not null,
  price numeric(10, 2) not null check (price > 0),
  image_url text,
  category text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.posts enable row level security;

-- Políticas de acesso para Posts
drop policy if exists "Qualquer pessoa autenticada pode ver as postagens" on public.posts;
create policy "Qualquer pessoa autenticada pode ver as postagens"
  on public.posts for select
  to authenticated
  using (true);

drop policy if exists "Vendedores podem criar postagens" on public.posts;
create policy "Vendedores podem criar postagens"
  on public.posts for insert
  to authenticated
  with check (auth.uid() = vendor_id);

drop policy if exists "Vendedores podem editar/deletar suas próprias postagens" on public.posts;
create policy "Vendedores podem editar/deletar suas próprias postagens"
  on public.posts for delete
  to authenticated
  using (auth.uid() = vendor_id);


-- 3. TABELA DE CURTIDAS (Onda 2)
create table if not exists public.likes (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  post_id uuid references public.posts(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique (user_id, post_id)
);

alter table public.likes enable row level security;

drop policy if exists "Visualização de curtidas pública para autenticados" on public.likes;
create policy "Visualização de curtidas pública para autenticados"
  on public.likes for select to authenticated using (true);

drop policy if exists "Usuários podem curtir postagens" on public.likes;
create policy "Usuários podem curtir postagens"
  on public.likes for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "Usuários podem descurtir" on public.likes;
create policy "Usuários podem descurtir"
  on public.likes for delete to authenticated using (auth.uid() = user_id);


-- 4. TABELA DE MENSAGENS DO CHAT (Onda 2 - Realtime)
create table if not exists public.chat_messages (
  id uuid default gen_random_uuid() primary key,
  sender_id uuid references public.profiles(id) on delete cascade not null,
  receiver_id uuid references public.profiles(id) on delete cascade not null,
  content text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.chat_messages enable row level security;

drop policy if exists "Usuários podem ver mensagens em que são remetente ou destinatário" on public.chat_messages;
create policy "Usuários podem ver mensagens em que são remetente ou destinatário"
  on public.chat_messages for select
  to authenticated
  using (auth.uid() = sender_id or auth.uid() = receiver_id);

drop policy if exists "Usuários podem enviar mensagens" on public.chat_messages;
create policy "Usuários podem enviar mensagens"
  on public.chat_messages for insert
  to authenticated
  with check (auth.uid() = sender_id);

-- Ativa o recurso Realtime do Supabase na tabela de chat com segurança (idempotente)
do $$
begin
  if not exists (
    select 1 from pg_publication_tables 
    where pubname = 'supabase_realtime' 
      and schemaname = 'public' 
      and tablename = 'chat_messages'
  ) then
    alter publication supabase_realtime add table public.chat_messages;
  end if;
end $$;


-- ==============================================================================
-- 5. TRIGGER AUTOMÁTICO DE CRIAÇÃO DE PERFIS (auth.users -> public.profiles)
-- ==============================================================================
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name, email, user_type, phone, trade_name, bio)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    new.email,
    coalesce(new.raw_user_meta_data->>'user_type', 'client'),
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'trade_name',
    new.raw_user_meta_data->>'bio'
  )
  on conflict (id) do update set
    name = excluded.name,
    user_type = excluded.user_type,
    phone = excluded.phone,
    trade_name = excluded.trade_name;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Políticas de visibilidade pública dos perfis e postagens
alter table public.profiles enable row level security;
drop policy if exists "Perfis são visíveis para qualquer pessoa" on public.profiles;
drop policy if exists "Perfis são visíveis para qualquer usuário autenticado" on public.profiles;
create policy "Perfis são visíveis para qualquer pessoa"
  on public.profiles for select
  using (true);

drop policy if exists "Permitir criacao de postagens" on public.posts;
drop policy if exists "Vendedores podem criar postagens" on public.posts;
create policy "Permitir criacao de postagens"
  on public.posts for insert
  with check (true);

drop policy if exists "Qualquer pessoa pode ver as postagens" on public.posts;
drop policy if exists "Qualquer pessoa autenticada pode ver as postagens" on public.posts;
create policy "Qualquer pessoa pode ver as postagens"
  on public.posts for select
  using (true);


