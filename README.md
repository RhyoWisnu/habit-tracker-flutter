# Habitracker - Flutter Habit Tracking App

A beautiful habit tracking application built with Flutter and Supabase, matching the Figma design exactly.

## Features

- 🎨 **Pixel-perfect UI** matching the Figma design
- 🔐 **Authentication** with Email, Google, and Facebook
- 📊 **Activity Progress** tracking with weekly charts
- ✅ **Habit Management** - Add, complete, and track habits
- 📱 **Multiple Screens**:
  - Splash Screen
  - Sign In / Sign Up
  - Home Screen with activity progress
  - Stats/Habits Screen
  - Add Habit Screen
  - Profile Screen

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Supabase account

### 2. Supabase Setup

1. Create a new project at [Supabase](https://supabase.com)
2. Get your Supabase URL and anon key
3. Update `lib/main.dart` with your credentials:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

### 3. Database Schema

Create the following table in Supabase:

```sql
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

-- Create policy for users to see only their habits
CREATE POLICY "Users can view own habits"
  ON habits FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy for users to insert own habits
CREATE POLICY "Users can insert own habits"
  ON habits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy for users to update own habits
CREATE POLICY "Users can update own habits"
  ON habits FOR UPDATE
  USING (auth.uid() = user_id);

-- Create policy for users to delete own habits
CREATE POLICY "Users can delete own habits"
  ON habits FOR DELETE
  USING (auth.uid() = user_id);
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Add Fonts

Download and add the following fonts to `assets/fonts/`:
- Rubik (Regular, Medium, SemiBold, Bold)
- Nunito Sans (Regular, Bold, ExtraBold)
- Airbnb Cereal (Bold)

Or use Google Fonts (already configured in the code).

### 6. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── habit.dart           # Habit data model
├── providers/
│   ├── auth_provider.dart   # Authentication state management
│   └── habit_provider.dart  # Habit state management
├── screens/
│   ├── splash_screen.dart
│   ├── sign_in_screen.dart
│   ├── sign_up_screen.dart
│   ├── home_screen.dart
│   ├── stats_screen.dart
│   ├── add_habit_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── bottom_nav_bar.dart
│   ├── habit_card.dart
│   └── activity_chart.dart
└── utils/
    ├── app_colors.dart      # Color constants
    └── app_text_styles.dart # Text style constants
```

## Design Colors

The app uses the exact colors from the Figma design:
- Primary Purple: `#8E97FD`
- Primary Purple Dark: `#4D57C8`
- Habit Colors: Orange, Purple, Yellow, Gray
- And many more matching the design system

## Notes

- The app uses Google Fonts for typography (Rubik, Nunito Sans)
- Images are stored in `assets/images/`
- All UI elements match the Figma design specifications
- Supabase handles authentication and data persistence

## License

This project is created for educational purposes.





