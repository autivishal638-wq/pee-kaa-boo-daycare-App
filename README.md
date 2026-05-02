// filepath: pee_ka_boo/README.md

# Pee-Kaa-Boo Play House - Daycare Management App

A mobile app to manage your daycare operations including child registration, attendance tracking, and fee management.

## Features

- **Child Registration**: Digital version of your paper registration form
- **Parent Management**: Contact details for both parents
- **Attendance Tracking**: Mark daily attendance (Present/Absent)
- **Fee Management**: Create invoices, track payments
- **Health Records**: Allergies, medical conditions
- **Multi-device Sync**: You and your wife can both use the app

## Tech Stack

- **Framework**: Flutter (iOS & Android)
- **Backend**: Firebase (Free tier)
- **Database**: Cloud Firestore
- **Auth**: Firebase Authentication

## Cost

- Firebase: Free (50K reads/day for 10-15 kids)
- Play Store: $25 one-time (optional)

## Getting Started

### Prerequisites

1. Install Flutter SDK: https://flutter.dev/docs/get-started/install
2. Install Android Studio (for building APKs)

### Setup Steps

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com
   - Create new project: "pee-ka-boo-play-house"
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Enable Firebase Storage

2. **Download google-services.json**
   - In Firebase Console → Project Settings
   - Download google-services.json
   - Place in: `android/app/google-services.json`

3. **Run the App**
   ```bash
   cd pee_ka_boo
   flutter pub get
   flutter run
   ```

4. **Create Admin Account**
   - First time, you'll need to create an admin account
   - Contact the developer to set up your login

## Project Structure

```
pee_ka_boo/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/
│   │   ├── child.dart         # Child data model
│   │   ├── attendance.dart    # Attendance model
│   │   └── payment.dart      # Payment model
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── child_list_screen.dart
│   │   ├── child_form_screen.dart
│   │   ├── child_detail_screen.dart
│   │   ├── attendance_screen.dart
│   │   ├── fee_screen.dart
│   │   └── settings_screen.dart
│   └── services/
│       └── firebase_service.dart
├── android/
│   └── app/
│       └── build.gradle
└── pubspec.yaml
```

## Fee Structure (As per T&C)

- Day Care: ₹1200/hour/month
- Snacks/Breakfast: ₹700/month
- Lunch: ₹1000/month
- Extra hours: ₹100/hour
- Late fee: ₹100/day after 5th
- First month: Before 15th = full, after 15th = half

## Support

For questions or help, contact the developer.

---

**Note**: This app requires Flutter to be installed on your machine. The code files are ready but need Flutter SDK to build and run.
