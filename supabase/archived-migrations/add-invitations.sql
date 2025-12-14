-- Add invitations table for home collaboration
CREATE TABLE IF NOT EXISTS invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  home_id UUID NOT NULL REFERENCES homes(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  token TEXT NOT NULL UNIQUE,
  invited_by UUID NOT NULL REFERENCES auth.users(id),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'expired')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + interval '7 days')
);

-- Add index for faster lookups
CREATE INDEX IF NOT EXISTS idx_invitations_token ON invitations(token);
CREATE INDEX IF NOT EXISTS idx_invitations_email ON invitations(email);
CREATE INDEX IF NOT EXISTS idx_invitations_home_id ON invitations(home_id);

-- Add super_admin column to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS super_admin BOOLEAN NOT NULL DEFAULT false;

COMMENT ON TABLE invitations IS 'Home collaboration invitations';
COMMENT ON COLUMN profiles.super_admin IS 'Super admin flag for debugging and system administration';
