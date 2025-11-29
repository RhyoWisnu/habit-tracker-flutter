# Supabase Setup Guide

## 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Create a new project
4. Note your project URL and anon key

## 2. Update Flutter App

Update `lib/main.dart` with your Supabase credentials:

```dart
await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key-here',
);
```

## 3. Create Database Table

Run this SQL in the Supabase SQL Editor:

```sql
-- Create habits table
CREATE TABLE habits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  icon TEXT DEFAULT '💧',
  color TEXT DEFAULT '#FF9966',
  frequency TEXT DEFAULT 'daily',
  target_days INTEGER DEFAULT 7,
  completed_days INTEGER DEFAULT 0,
  completed_dates TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE habits ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view own habits"
  ON habits FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own habits"
  ON habits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own habits"
  ON habits FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own habits"
  ON habits FOR DELETE
  USING (auth.uid() = user_id);
```

## 4. Configure Authentication Providers (Optional)

### Google OAuth
1. Go to Authentication > Providers in Supabase dashboard
2. Enable Google provider
3. Add your OAuth credentials

### Facebook OAuth
1. Go to Authentication > Providers in Supabase dashboard
2. Enable Facebook provider
3. Add your OAuth credentials

## 5. Test the Connection

Run the app and test:
- Sign up with email
- Sign in with email
- Add a habit
- View habits





