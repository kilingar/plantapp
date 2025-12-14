-- ============================================================================
-- PLANT DIARY APP - COMPLETE DATABASE SETUP
-- ============================================================================
-- Run this file in your Supabase SQL Editor to set up the complete database
-- This includes all tables, indexes, RLS policies, and features
-- ============================================================================

-- ============================================================================
-- 1. CORE TABLES
-- ============================================================================

-- Profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  super_admin BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Homes table
CREATE TABLE IF NOT EXISTS public.homes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  owner_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  google_drive_folder_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Home members table (for collaboration)
CREATE TABLE IF NOT EXISTS public.home_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  home_id UUID REFERENCES public.homes(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  role TEXT CHECK (role IN ('owner', 'member')) DEFAULT 'member',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(home_id, user_id)
);

-- Invitations table (for home collaboration)
CREATE TABLE IF NOT EXISTS public.invitations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  home_id UUID REFERENCES public.homes(id) ON DELETE CASCADE NOT NULL,
  email TEXT NOT NULL,
  token TEXT NOT NULL UNIQUE,
  invited_by UUID REFERENCES auth.users(id) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'expired')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT (NOW() + interval '7 days')
);

-- Zones table (rooms/areas in the house)
CREATE TABLE IF NOT EXISTS public.zones (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  home_id UUID REFERENCES public.homes(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Plants table
CREATE TABLE IF NOT EXISTS public.plants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  zone_id UUID REFERENCES public.zones(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  species TEXT,
  description TEXT,
  acquisition_date DATE,
  watering_frequency_days INTEGER,
  last_watered DATE,
  image_url TEXT,
  status TEXT CHECK (status IN ('active', 'archived')) DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Plant diary entries table
CREATE TABLE IF NOT EXISTS public.plant_diary_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  plant_id UUID REFERENCES public.plants(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  entry_type TEXT CHECK (entry_type IN ('watering', 'fertilizing', 'pruning', 'observation', 'other')) NOT NULL,
  notes TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- 2. INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_homes_owner_id ON public.homes(owner_id);
CREATE INDEX IF NOT EXISTS idx_home_members_home_id ON public.home_members(home_id);
CREATE INDEX IF NOT EXISTS idx_home_members_user_id ON public.home_members(user_id);
CREATE INDEX IF NOT EXISTS idx_invitations_token ON public.invitations(token);
CREATE INDEX IF NOT EXISTS idx_invitations_email ON public.invitations(email);
CREATE INDEX IF NOT EXISTS idx_invitations_home_id ON public.invitations(home_id);
CREATE INDEX IF NOT EXISTS idx_zones_home_id ON public.zones(home_id);
CREATE INDEX IF NOT EXISTS idx_plants_zone_id ON public.plants(zone_id);
CREATE INDEX IF NOT EXISTS idx_plants_status ON public.plants(status);
CREATE INDEX IF NOT EXISTS idx_plant_diary_entries_plant_id ON public.plant_diary_entries(plant_id);
CREATE INDEX IF NOT EXISTS idx_plant_diary_entries_user_id ON public.plant_diary_entries(user_id);

-- ============================================================================
-- 3. FUNCTIONS AND TRIGGERS
-- ============================================================================

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to automatically add home owner as member
CREATE OR REPLACE FUNCTION public.add_owner_as_member()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.home_members (home_id, user_id, role)
  VALUES (NEW.id, NEW.owner_id, 'owner');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to add owner as member when home is created
DROP TRIGGER IF EXISTS on_home_created ON public.homes;
CREATE TRIGGER on_home_created
  AFTER INSERT ON public.homes
  FOR EACH ROW EXECUTE FUNCTION public.add_owner_as_member();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_homes_updated_at ON public.homes;
CREATE TRIGGER update_homes_updated_at
  BEFORE UPDATE ON public.homes
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_zones_updated_at ON public.zones;
CREATE TRIGGER update_zones_updated_at
  BEFORE UPDATE ON public.zones
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_plants_updated_at ON public.plants;
CREATE TRIGGER update_plants_updated_at
  BEFORE UPDATE ON public.plants
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ============================================================================
-- 4. ROW LEVEL SECURITY (RLS) POLICIES - DISABLED FOR CLIENT-SIDE USE
-- ============================================================================
-- Note: RLS is disabled for easier client-side access
-- For production, consider enabling RLS and using service role key server-side

ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.homes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.home_members DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.zones DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.plants DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.plant_diary_entries DISABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 5. STORAGE BUCKETS AND POLICIES
-- ============================================================================
-- Note: Run these separately if buckets don't exist

-- Create storage bucket for plant images
INSERT INTO storage.buckets (id, name, public)
VALUES ('plant-images', 'plant-images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for plant-images bucket
DROP POLICY IF EXISTS "Anyone can upload plant images" ON storage.objects;
CREATE POLICY "Anyone can upload plant images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'plant-images');

DROP POLICY IF EXISTS "Anyone can view plant images" ON storage.objects;
CREATE POLICY "Anyone can view plant images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'plant-images');

DROP POLICY IF EXISTS "Users can update their plant images" ON storage.objects;
CREATE POLICY "Users can update their plant images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'plant-images');

DROP POLICY IF EXISTS "Users can delete their plant images" ON storage.objects;
CREATE POLICY "Users can delete their plant images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'plant-images');

-- ============================================================================
-- 6. COMMENTS AND DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE public.profiles IS 'User profiles extending auth.users';
COMMENT ON TABLE public.homes IS 'User homes/properties for organizing plants';
COMMENT ON TABLE public.home_members IS 'Home membership for collaboration';
COMMENT ON TABLE public.invitations IS 'Home collaboration invitations';
COMMENT ON TABLE public.zones IS 'Zones/rooms within a home';
COMMENT ON TABLE public.plants IS 'Individual plants being tracked';
COMMENT ON TABLE public.plant_diary_entries IS 'Diary entries for plant care history';

COMMENT ON COLUMN public.profiles.super_admin IS 'Super admin flag for system administration';
COMMENT ON COLUMN public.homes.google_drive_folder_url IS 'Google Drive folder URL for high-quality image backup';
COMMENT ON COLUMN public.zones.image_url IS 'URL to zone photo stored in Supabase Storage';
COMMENT ON COLUMN public.plants.image_url IS 'URL to plant photo stored in Supabase Storage';
COMMENT ON COLUMN public.invitations.expires_at IS 'Invitation expiration date (7 days from creation)';

-- ============================================================================
-- SETUP COMPLETE!
-- ============================================================================
-- Next steps:
-- 1. Verify all tables were created successfully
-- 2. Check storage bucket 'plant-images' exists and is public
-- 3. (Optional) Grant super admin access to your account:
--    UPDATE profiles SET super_admin = true WHERE email = 'your@email.com';
-- ============================================================================
