-- Create profiles table (automatically created from auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create homes table
CREATE TABLE IF NOT EXISTS public.homes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  owner_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create home_members table (for sharing homes with partners/family)
CREATE TABLE IF NOT EXISTS public.home_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  home_id UUID REFERENCES public.homes(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  role TEXT CHECK (role IN ('owner', 'member')) DEFAULT 'member',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(home_id, user_id)
);

-- Create zones table (rooms/areas in the house)
CREATE TABLE IF NOT EXISTS public.zones (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  home_id UUID REFERENCES public.homes(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create plants table
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

-- Create plant_diary_entries table
CREATE TABLE IF NOT EXISTS public.plant_diary_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  plant_id UUID REFERENCES public.plants(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  entry_type TEXT CHECK (entry_type IN ('watering', 'fertilizing', 'pruning', 'observation', 'other')) NOT NULL,
  notes TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_homes_owner_id ON public.homes(owner_id);
CREATE INDEX IF NOT EXISTS idx_home_members_home_id ON public.home_members(home_id);
CREATE INDEX IF NOT EXISTS idx_home_members_user_id ON public.home_members(user_id);
CREATE INDEX IF NOT EXISTS idx_zones_home_id ON public.zones(home_id);
CREATE INDEX IF NOT EXISTS idx_plants_zone_id ON public.plants(zone_id);
CREATE INDEX IF NOT EXISTS idx_plants_status ON public.plants(status);
CREATE INDEX IF NOT EXISTS idx_plant_diary_entries_plant_id ON public.plant_diary_entries(plant_id);
CREATE INDEX IF NOT EXISTS idx_plant_diary_entries_user_id ON public.plant_diary_entries(user_id);

-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.homes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.home_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plant_diary_entries ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can view profiles of home members"
  ON public.profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.home_members hm1
      JOIN public.home_members hm2 ON hm1.home_id = hm2.home_id
      WHERE hm1.user_id = auth.uid() AND hm2.user_id = profiles.id
    )
  );

-- Homes policies
CREATE POLICY "Users can view homes they are members of"
  ON public.homes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.home_members
      WHERE home_id = homes.id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create homes"
  ON public.homes FOR INSERT
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Owners can update their homes"
  ON public.homes FOR UPDATE
  USING (owner_id = auth.uid());

CREATE POLICY "Owners can delete their homes"
  ON public.homes FOR DELETE
  USING (owner_id = auth.uid());

-- Home members policies
CREATE POLICY "Users can view home members of their homes"
  ON public.home_members FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.home_members hm
      WHERE hm.home_id = home_members.home_id AND hm.user_id = auth.uid()
    )
  );

CREATE POLICY "Home owners can add members"
  ON public.home_members FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.homes
      WHERE id = home_id AND owner_id = auth.uid()
    )
  );

CREATE POLICY "Home owners can remove members"
  ON public.home_members FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.homes
      WHERE id = home_id AND owner_id = auth.uid()
    )
  );

-- Zones policies
CREATE POLICY "Users can view zones in their homes"
  ON public.zones FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.home_members
      WHERE home_id = zones.home_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Home members can create zones"
  ON public.zones FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.home_members
      WHERE home_id = zones.home_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Home members can update zones"
  ON public.zones FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.home_members
      WHERE home_id = zones.home_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Home owners can delete zones"
  ON public.zones FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.homes
      JOIN public.home_members ON homes.id = home_members.home_id
      WHERE zones.home_id = homes.id AND homes.owner_id = auth.uid()
    )
  );

-- Plants policies
CREATE POLICY "Users can view plants in their homes"
  ON public.plants FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.zones
      JOIN public.home_members ON zones.home_id = home_members.home_id
      WHERE plants.zone_id = zones.id AND home_members.user_id = auth.uid()
    )
  );

CREATE POLICY "Home members can create plants"
  ON public.plants FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.zones
      JOIN public.home_members ON zones.home_id = home_members.home_id
      WHERE plants.zone_id = zones.id AND home_members.user_id = auth.uid()
    )
  );

CREATE POLICY "Home members can update plants"
  ON public.plants FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.zones
      JOIN public.home_members ON zones.home_id = home_members.home_id
      WHERE plants.zone_id = zones.id AND home_members.user_id = auth.uid()
    )
  );

CREATE POLICY "Home members can delete plants"
  ON public.plants FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.zones
      JOIN public.home_members ON zones.home_id = home_members.home_id
      WHERE plants.zone_id = zones.id AND home_members.user_id = auth.uid()
    )
  );

-- Plant diary entries policies
CREATE POLICY "Users can view diary entries for plants in their homes"
  ON public.plant_diary_entries FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.plants
      JOIN public.zones ON plants.zone_id = zones.id
      JOIN public.home_members ON zones.home_id = home_members.home_id
      WHERE plant_diary_entries.plant_id = plants.id AND home_members.user_id = auth.uid()
    )
  );

CREATE POLICY "Home members can create diary entries"
  ON public.plant_diary_entries FOR INSERT
  WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM public.plants
      JOIN public.zones ON plants.zone_id = zones.id
      JOIN public.home_members ON zones.home_id = home_members.home_id
      WHERE plant_diary_entries.plant_id = plants.id AND home_members.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update their own diary entries"
  ON public.plant_diary_entries FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Users can delete their own diary entries"
  ON public.plant_diary_entries FOR DELETE
  USING (user_id = auth.uid());

-- Function to automatically create a profile when a user signs up
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

-- Function to automatically add user as home owner when creating a home
CREATE OR REPLACE FUNCTION public.handle_new_home()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.home_members (home_id, user_id, role)
  VALUES (NEW.id, NEW.owner_id, 'owner');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to add owner as home member
DROP TRIGGER IF EXISTS on_home_created ON public.homes;
CREATE TRIGGER on_home_created
  AFTER INSERT ON public.homes
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_home();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updating updated_at
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS update_homes_updated_at ON public.homes;
CREATE TRIGGER update_homes_updated_at
  BEFORE UPDATE ON public.homes
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS update_zones_updated_at ON public.zones;
CREATE TRIGGER update_zones_updated_at
  BEFORE UPDATE ON public.zones
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS update_plants_updated_at ON public.plants;
CREATE TRIGGER update_plants_updated_at
  BEFORE UPDATE ON public.plants
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
