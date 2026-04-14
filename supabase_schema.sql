-- SQL Schema for Structura App in Supabase

-- 1. Table for Structures
CREATE TABLE IF NOT EXISTS structures (
  id UUID PRIMARY KEY DEFAULT auth.uid(), -- Or gen_random_uuid() if not owner-specific
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  materials JSONB NOT NULL DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Table for Projects
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  client TEXT NOT NULL,
  type TEXT CHECK (type IN ('proyecto', 'cotización')) NOT NULL,
  structures JSONB NOT NULL DEFAULT '[]',
  status TEXT CHECK (status IN ('active', 'completed', 'archived')) DEFAULT 'active',
  completion_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Enable Row Level Security (RLS)
ALTER TABLE structures ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- 4. Policies for Structures
CREATE POLICY "Users can manage their own structures" ON structures
  FOR ALL USING (auth.uid() = user_id);

-- 5. Policies for Projects
CREATE POLICY "Users can manage their own projects" ON projects
  FOR ALL USING (auth.uid() = user_id);
