# OAuth Fix for Supabase Flutter

The `signInWithOAuth` method may not exist in your version of Supabase Flutter.

## Option 1: Check Supabase Flutter 2.x Documentation
Visit: https://supabase.com/docs/reference/dart/auth-signinwithoauth

## Option 2: Use Alternative Method
Try using:
```dart
await _supabase.auth.signInWithOAuth(
  provider: OAuthProvider.google,
  redirectTo: 'io.supabase.habitracker://login-callback/',
);
```

## Option 3: Temporarily Disable OAuth
Comment out the OAuth methods and only use email authentication for now.



