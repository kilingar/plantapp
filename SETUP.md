# Quick Setup Guide

## For New Projects (Recommended)

**Copy and run this entire file in Supabase SQL Editor:**
```
/supabase/complete-setup.sql
```

That's it! Everything is set up.

## Optional: Make Yourself Super Admin

```sql
UPDATE profiles 
SET super_admin = true 
WHERE email = 'your@email.com';
```

## What Gets Created

✅ All core tables (profiles, homes, zones, plants, diary)  
✅ Collaboration tables (home_members, invitations)  
✅ All indexes for performance  
✅ Triggers for auto-updating timestamps  
✅ Storage bucket for images  
✅ Storage policies  
✅ Comments and documentation  

## If You Already Have the Base Schema

Just run the upgrade commands in `COLLABORATION_FEATURES.md` to add:
- Zone images
- Invitations table
- Super admin support
- Google Drive field

## Verifying Setup

Check these tables exist in Supabase:
- profiles
- homes
- home_members
- invitations
- zones
- plants
- plant_diary_entries

Check storage bucket exists:
- plant-images (public)

## Need Help?

See the full `README.md` for detailed documentation.
