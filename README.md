# 🌱 Plant Diary App

A mobile-first web application for tracking and managing your plant collection, built with Next.js and Supabase.

## 📱 Features

### Core Features
- **Authentication**: Email/password, Google OAuth, and magic link support
- **Multi-Home Management**: Create and manage multiple homes/properties
- **Zone Organization**: Organize plants by location (living room, bedroom, balcony, etc.)
  - Add photos to zones
  - Clickable zone cards with thumbnails
- **Plant Tracking**: 
  - Add plants with photos, species, descriptions
  - Track watering schedules with automatic reminders
  - Mark plants as watered with one click
  - Archive or delete plants
- **Plant Diary**: Keep a journal with photos and notes for each plant
- **Photo Upload**: 
  - Direct camera access on mobile devices
  - Automatic image compression (100KB or 500KB based on settings)
  - WebP format for optimal file sizes
  - Adaptive quality based on Google Drive backup configuration
- **Mobile-First Design**: Optimized for phone usage with bottom navigation

### Collaboration Features
- **Member Invitations**: Invite family/roommates to collaborate on a home
  - Generate shareable invitation links
  - 7-day expiration on invites
  - Email verification required
- **Member Management**: 
  - View all home members
  - Owner can add/remove members
  - Role-based permissions (owner/member)
- **Home Switching**: Easily switch between multiple homes
- **Super Admin Panel**: Debug and view system-wide data (admin users only)

## 🚀 Quick Start

### Prerequisites
- Node.js 20.9.0 or higher
- Supabase account

### Installation

1. **Clone and install dependencies:**
   ```bash
   npm install
   ```

2. **Set up environment variables:**
   
   Create `.env.local` file:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. **Set up the database:**
   - Go to your Supabase project SQL Editor
   - Copy and run the entire contents of `/supabase/complete-setup.sql`
   - This will create all tables, indexes, triggers, and storage policies
   - (Optional) Grant yourself super admin access by running:
     ```sql
     UPDATE profiles SET super_admin = true WHERE email = 'your@email.com';
     ```

4. **Start the development server:**
   ```bash
   npm run dev
   ```

5. **Open your browser:**
   
   Navigate to `http://localhost:3000`

## 📂 Project Structure

```
plantapp/
├── app/
│   ├── auth/
│   │   ├── login/page.tsx         # Login page
│   │   ├── signup/page.tsx        # Signup page
│   │   └── callback/route.ts      # OAuth callback
│   ├── dashboard/
│   │   ├── layout.tsx             # Dashboard layout with nav
│   │   ├── page.tsx               # Main dashboard
│   │   ├── members/page.tsx       # Member management
│   │   ├── plants/
│   │   │   ├── page.tsx           # Plants list
│   │   │   ├── new/page.tsx       # Add plant
│   │   │   └── [id]/page.tsx      # Plant detail/edit
│   │   ├── zones/
│   │   │   ├── page.tsx           # Zones list
│   │   │   ├── new/page.tsx       # Add zone
│   │   │   └── [id]/page.tsx      # Zone detail/edit
│   │   └── settings/page.tsx      # Settings (Google Drive)
│   ├── invite/[token]/page.tsx    # Invitation acceptance
│   ├── admin/page.tsx             # Super admin panel
│   ├── layout.tsx                 # Root layout
│   └── page.tsx                   # Landing page
├── lib/
│   ├── supabase/
│   │   ├── client.ts              # Supabase client
│   │   └── database.types.ts      # Generated types
│   └── utils/
│       └── imageUpload.ts         # Image compression
└── supabase/
    ├── complete-setup.sql         # ⭐ Use this for setup
    └── archived-migrations/       # Old migration files
```

## 🗄️ Database Schema

### Tables
- **profiles**: User profiles (auto-created on signup, includes super_admin flag)
- **homes**: Properties where plants are kept (with optional Google Drive URL)
- **home_members**: Multi-user access for collaboration (owner/member roles)
- **invitations**: Collaboration invitations with 7-day expiration
- **zones**: Locations within a home (with optional photos)
- **plants**: Plant records with watering schedules (linked to zones)
- **plant_diary_entries**: Journal entries with photos and notes

### Storage
- **plant-images** bucket: Stores all plant and zone photos (public access)

## ⚙️ Configuration

### Image Quality Settings

Navigate to **Dashboard → Settings** to configure:
- **Without Google Drive**: Images compressed to ~100KB (standard quality)
- **With Google Drive URL**: Images compressed to ~500KB (high quality for backup)

This affects all photos uploaded to plants and zones for that home.

### Super Admin Access

To access the admin panel at `/admin`, you need super admin privileges:

```sql
UPDATE profiles 
SET super_admin = true 
WHERE email = 'your-email@example.com';
```

## 👥 Collaboration

### Inviting Members

1. Go to **Dashboard → Members**
2. Enter the email address of the person you want to invite
3. Click "Send Invitation" to generate a link
4. Share the invitation link via email or messaging
5. The recipient has 7 days to accept the invitation

### Accepting Invitations

1. Click the invitation link
2. Log in with the invited email address
3. Click "Accept Invitation"
4. You'll be redirected to the shared home's dashboard

### Member Roles

- **Owner**: Can invite/remove members, delete the home, full access
- **Member**: Can add/edit plants, zones, and diary entries

## 🛠️ Development

```bash
npm run dev      # Start dev server
npm run build    # Build for production
npm run lint     # Run linter
```

## 📱 Mobile Usage

- Bottom navigation for easy access
- Camera integration for photos
- Touch-friendly interface
- Responsive design

## 🐛 Troubleshooting

### Images not uploading
- Check that the `plant-images` storage bucket exists in Supabase
- Verify storage policies allow authenticated uploads
- The `complete-setup.sql` includes storage setup

### Authentication issues
- Verify `.env.local` has correct credentials
- Enable desired auth providers in Supabase Dashboard
- Check OAuth redirect URLs are configured

### Database errors
- Ensure you ran `/supabase/complete-setup.sql` completely
- Verify all tables were created successfully
- RLS is disabled by default for easier client-side access

### Plants showing in wrong home
- This was fixed to properly filter plants by home through zones
- If you see this issue, refresh the page or clear browser cache

### Invitation link not working
- Check that the invitation hasn't expired (7 days max)
- Verify the recipient is logging in with the invited email address
- Check the `invitations` table status column

## 📚 Additional Documentation

- **COLLABORATION_FEATURES.md**: Detailed collaboration feature documentation
- **supabase/complete-setup.sql**: Complete database schema with comments

## 📝 Tech Stack

- Next.js 15.0.3 (App Router)
- Tailwind CSS 4
- TypeScript
- Supabase (PostgreSQL + Auth + Storage)
- WebP image format

---

**Made with 🌿 for plant lovers**
