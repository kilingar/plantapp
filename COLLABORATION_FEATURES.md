# Collaboration Features - Setup Instructions

## Overview
Added member collaboration features including:
- Invite members to homes via email links
- Home switching and creation
- Super admin panel for debugging
- Zone photos
- Proper plant filtering by home

## Database Setup

### Option 1: Fresh Installation (Recommended)
If you're setting up a new database, use the complete setup file:

**Run this in your Supabase SQL Editor:**
```bash
# Copy the entire contents of /supabase/complete-setup.sql and run it
```

This single file includes:
- All core tables (profiles, homes, zones, plants, diary)
- Collaboration tables (home_members, invitations)
- Zone images support
- Super admin functionality
- All indexes and triggers
- Storage bucket setup

### Option 2: Upgrading Existing Database
If you already have the base schema running, add only the new features:

**Run this in your Supabase SQL Editor:**
```sql
-- Add zone images
ALTER TABLE zones ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Add invitations table
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

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_invitations_token ON invitations(token);
CREATE INDEX IF NOT EXISTS idx_invitations_email ON invitations(email);
CREATE INDEX IF NOT EXISTS idx_invitations_home_id ON invitations(home_id);

-- Add super admin support
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS super_admin BOOLEAN NOT NULL DEFAULT false;

-- Add Google Drive support (if not already added)
ALTER TABLE homes ADD COLUMN IF NOT EXISTS google_drive_folder_url TEXT;

-- Add comments
COMMENT ON TABLE invitations IS 'Home collaboration invitations';
COMMENT ON COLUMN profiles.super_admin IS 'Super admin flag for debugging and system administration';
COMMENT ON COLUMN zones.image_url IS 'URL to zone image stored in Supabase Storage';
COMMENT ON COLUMN homes.google_drive_folder_url IS 'Google Drive folder URL for high-quality image backup';
```

### Grant Super Admin Access (Optional)
To access the admin panel, grant yourself super admin privileges:
```sql
UPDATE profiles 
SET super_admin = true 
WHERE email = 'your-email@example.com';
```

## New Features

### Member Management (`/dashboard/members`)
- View all members of a home
- Invite new members via email link
- Pending invitations list
- Copy invitation links to clipboard
- Cancel pending invitations
- Remove members (owner only)
- Role-based permissions (owner/member)

### Invitation System (`/invite/[token]`)
- 7-day expiration on invitations
- Email verification (must log in with invited email)
- Accept or decline invitations
- Automatic member addition on acceptance
- Redirects to dashboard after accepting

### Super Admin Panel (`/admin`)
- View all homes in the system
- View all users and their roles
- See home members for each home
- Debug information (IDs, creation dates)
- System statistics
- Only accessible to users with `super_admin = true`

### Dashboard Improvements
- "Members" button to manage collaborators
- "New Home" button to create additional homes
- Modal for creating new homes
- Admin badge in header (super admins only)
- Home switching dropdown (when multiple homes)

## Usage

1. **Invite a Member:**
   - Go to Dashboard → Members
   - Enter email address
   - Click "Send Invitation"
   - Copy and share the invitation link

2. **Accept an Invitation:**
   - Click the invitation link
   - Log in with the invited email address
   - Click "Accept Invitation"
   - Access the home immediately

3. **Create a New Home:**
   - Click "New Home" on dashboard
   - Enter home name
   - Click "Create"
   - Home is added to your list

4. **Access Admin Panel:**
   - Must be marked as super_admin in database
   - Click "Admin" badge in header
   - View all system data for debugging

## Files Created

- `/app/dashboard/members/page.tsx` - Member management
- `/app/invite/[token]/page.tsx` - Invitation acceptance
- `/app/admin/page.tsx` - Super admin panel
- `/supabase/add-invitations.sql` - Migration script
- `/supabase/add-zone-images.sql` - Zone images migration

## Files Modified

- `/lib/supabase/database.types.ts` - Added invitations table and super_admin field
- `/app/dashboard/page.tsx` - Added Members and New Home buttons, create home modal
- `/app/dashboard/layout.tsx` - Added super admin check and Admin link in header

## Security Notes

- Invitations expire after 7 days
- Email must match invitation
- Only home owners can invite/remove members
- Super admin access is database-controlled
- RLS policies should be reviewed for production use
