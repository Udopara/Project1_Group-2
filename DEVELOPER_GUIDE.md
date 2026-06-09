# Developer Guide — formative_assignment1

> Flutter · Campus Social App · Material 3 · June 2026

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Setup & Installation](#2-setup--installation)
3. [Theme System](#3-theme-system)
   - [AppColors](#appcolors)
   - [AppTextStyles](#apptextstyles)
   - [AppSpacing](#appspacing)
   - [AppRadius](#appradius)
   - [AppShadows](#appshadows)
   - [AppGradients](#appgradients)
4. [Dummy Database](#4-dummy-database)
   - [Data models](#data-models)
   - [Enums](#enums)
   - [Seed data](#seed-data)
   - [Lookup helpers](#lookup-helpers)
   - [Usage examples](#usage-examples)
5. [Session Management](#5-session-management)
   - [Session class](#session-class)
   - [Login screen integration](#login-screen-integration)
   - [Guarding routes](#guarding-routes)
6. [Quick Reference](#6-quick-reference)

---

## 1. Project Overview

**formative_assignment1** is a Flutter campus social app for students to discover events, join clubs, chat with peers, and share posts. The codebase ships with a complete design token system (`app_theme.dart`), an in-memory dummy database (`dummy_database.dart`), and a lightweight session manager (`session.dart`) so you can build and prototype screens without a backend.

### File structure

```
lib/
├── data/
│   ├── dummy_database.dart   # all models + seed data + lookup helpers
│   └── session.dart          # static session state (currentUser, login, logout)
├── theme/
│   └── app_theme.dart        # colors, typography, spacing, shadows, gradients
├── ui/
│   ├── screen1.dart          # first screen (extend this)
│   └── screen2.dart          # second screen (extend this)
└── main.dart                 # entry point — wires AppTheme.light

assets/
└── fonts/
    ├── PlusJakartaSans-Regular.ttf     # weight 400
    ├── PlusJakartaSans-Medium.ttf      # weight 500
    ├── PlusJakartaSans-SemiBold.ttf    # weight 600
    └── PlusJakartaSans-Bold.ttf        # weight 700
```

> **Design source:** Tokens and layout decisions are derived from the Figma file *"Profile Hero Section (Asymmetric Layout)"*. Refer to it for spacing and component behaviour before building new screens.

---

## 2. Setup & Installation

### Prerequisites

| Tool | Minimum version | Check command |
|---|---|---|
| Flutter SDK | 3.11.x | `flutter --version` |
| Dart SDK | 3.11.x (bundled) | `dart --version` |
| Android Studio / VS Code | Any recent | — |
| Xcode (iOS builds) | 15+ | `xcode-select -p` |

### Font installation

The app uses **Plus Jakarta Sans**. Flutter will not compile without the font files in place — this step is required before running.

1. Download the font family from Google Fonts (search "Plus Jakarta Sans").
2. Copy these four files into `assets/fonts/` in the project root:

```
assets/fonts/PlusJakartaSans-Regular.ttf
assets/fonts/PlusJakartaSans-Medium.ttf
assets/fonts/PlusJakartaSans-SemiBold.ttf
assets/fonts/PlusJakartaSans-Bold.ttf
```

> **Font filenames must match exactly.** The `pubspec.yaml` asset paths are case-sensitive. Google Fonts exports files with these exact names — do not rename them.

### Installing dependencies & running

```bash
# Install pub dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Run on a specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome   # webF
```

### Verify everything works

After running you should see a screen titled **"Screen 1"** rendered with the `scaffoldBg` background colour (`#F5F6FF`) — a faint lavender-white. If the background is plain white, the theme is not wired correctly. Check `main.dart`:

```dart
return MaterialApp(
  title: 'Formative Assignment 1',
  theme: AppTheme.light,   // ← must be present
  home: const Screen1(),
);
```

---

## 3. Theme System

All design tokens live in `lib/theme/app_theme.dart`. Import it once per file — never hardcode colours, font sizes, or spacing values directly in widget code.

```dart
import 'package:formative_assignment1/theme/app_theme.dart';
```

### AppColors

Every colour in the app is a static constant on `AppColors`.

| Constant | Hex | Use |
|---|---|---|
| `AppColors.primary` | `#4648D4` | Buttons, active states, links |
| `AppColors.primaryLight` | `#F2F3FF` | Input fill, chip background |
| `AppColors.gradientStart` | `#4648D4` | Hero banner gradient (left) |
| `AppColors.gradientEnd` | `#B90538` | Hero banner gradient (right) |
| `AppColors.white` | `#FFFFFF` | Card backgrounds, surfaces |
| `AppColors.cardBorder` | `#EAEDFF` | Card / divider borders |
| `AppColors.scaffoldBg` | `#F5F6FF` | Page background |
| `AppColors.textDark` | `#131B2E` | Headings, primary text |
| `AppColors.textMedium` | `#464554` | Body text |
| `AppColors.textMuted` | `#767586` | Captions, placeholders |
| `AppColors.success` | `#00885D` | Online badge, positive states |
| `AppColors.error` | `#D32F2F` | Errors, destructive actions |
| `AppColors.warning` | `#F59E0B` | Warning states |
| `AppColors.statValue` | `#4648D4` | Stat tile numbers |
| `AppColors.statTileBg` | `#F2F3FF` | Stat tile background |
| `AppColors.onlineBadge` | `#00885D` | Online presence dot |

```dart
Container(
  color: AppColors.scaffoldBg,
  child: Text('Hello', style: TextStyle(color: AppColors.textDark)),
)
```

### AppTextStyles

Pre-built `TextStyle` objects — all using Plus Jakarta Sans with the correct weight, size, line-height, and colour already applied.

| Style | Size | Weight | Colour | Use |
|---|---|---|---|---|
| `AppTextStyles.displayLarge` | 32px | 700 | textDark | Hero display text |
| `AppTextStyles.headingLarge` | 24px | 600 | textDark | Screen titles |
| `AppTextStyles.headingMedium` | 20px | 600 | textDark | Section headings |
| `AppTextStyles.headingSmall` | 16px | 600 | textDark | Card titles, AppBar |
| `AppTextStyles.bodyLarge` | 16px | 400 | textMedium | Primary body copy |
| `AppTextStyles.bodyMedium` | 14px | 400 | textMedium | General body text |
| `AppTextStyles.bodySmall` | 12px | 400 | textMuted | Secondary body |
| `AppTextStyles.labelMedium` | 14px | 500 | textMedium | Button labels |
| `AppTextStyles.labelSmall` | 11px | 500 | textMuted | Tags, chips |
| `AppTextStyles.statValue` | 18px | 600 | statValue | Stat tile number |
| `AppTextStyles.statLabel` | 11px | 500 | textMuted | Stat tile label |
| `AppTextStyles.caption` | 12px | 400 | textMuted | Timestamps, meta info |

```dart
// Use as-is
Text('Aline Umuhoza', style: AppTextStyles.headingMedium)

// Override a single property with copyWith
Text('Online', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success))
```

### AppSpacing

```dart
AppSpacing.xs    //  4
AppSpacing.sm    //  8
AppSpacing.md    // 12
AppSpacing.lg    // 16  ← most common gap
AppSpacing.xl    // 24
AppSpacing.xxl   // 32
AppSpacing.xxxl  // 48

// Component-specific
AppSpacing.cardPadding       // 24  — internal card padding
AppSpacing.statGridGap       // 12  — gap between stat tiles
AppSpacing.avatarBorderWidth //  4  — white ring around avatar
AppSpacing.badgeBorderWidth  //  2  — online badge border
```

### AppRadius

```dart
AppRadius.xs      //  4
AppRadius.sm      //  8
AppRadius.md      // 12
AppRadius.lg      // 16
AppRadius.xl      // 24
AppRadius.full    // 9999

// Component-specific
AppRadius.card           // 16
AppRadius.statTile       // 12
AppRadius.gradientBanner // 12
AppRadius.avatar         // 9999  (circle)
AppRadius.badge          // 9999
AppRadius.chip           // 9999
AppRadius.button         // 12
AppRadius.input          // 12
```

### AppShadows

```dart
// Use inside BoxDecoration
BoxDecoration(boxShadow: AppShadows.card)      // standard card shadow
BoxDecoration(boxShadow: AppShadows.avatar)    // floating avatar
BoxDecoration(boxShadow: AppShadows.elevated)  // elevated panels
```

### AppGradients

```dart
BoxDecoration(gradient: AppGradients.heroBanner)  // indigo → crimson (profile banner)
BoxDecoration(gradient: AppGradients.primarySoft) // light indigo → primary
```

---

## 4. Dummy Database

`lib/data/dummy_database.dart` is a self-contained, in-memory dataset. It has no external dependencies and requires no network access — perfect for UI prototyping and offline development.

```dart
import 'package:formative_assignment1/data/dummy_database.dart';
```

### Data models

| Model | Key fields |
|---|---|
| `UserModel` | id, username, email, password, fullName, avatarUrl, campus, department, yearOfStudy, role, isOnline, clubIds, eventIds, friendIds, postIds, metadata |
| `EventModel` | id, title, description, organizerId, clubId, category, location, campus, startDate, endDate, bannerUrl, maxAttendees, attendeeIds, isPublic, metadata |
| `ClubModel` | id, name, description, leaderId, category, campus, logoUrl, memberIds, eventIds, isVerified, metadata |
| `PostModel` | id, authorId, content, type, imageUrls, likeIds, comments, clubId?, eventId?, isPinned, createdAt, updatedAt, metadata |
| `CommentModel` | id, authorId, content, likeIds, createdAt, metadata |
| `MessageModel` | id, senderId, receiverId, content, status, sentAt, isDeleted, metadata |
| `ChatThreadModel` | id, participantIds, messages, lastActivity, metadata |
| `NotificationModel` | id, userId, title, body, type, isRead, createdAt, metadata |

### Enums

| Enum | Values |
|---|---|
| `UserRole` | `student` · `admin` · `clubLead` · `eventOrganizer` |
| `EventCategory` | `academic` · `social` · `sports` · `tech` · `cultural` · `career` |
| `PostType` | `text` · `image` · `poll` · `announcement` |
| `MessageStatus` | `sent` · `delivered` · `read` |
| `ClubCategory` | `tech` · `arts` · `sports` · `academic` · `social` · `business` |

### Seed data

#### Users

| ID | Name | Role | Online | Department |
|---|---|---|---|---|
| `usr_001` | Aline Umuhoza | student | ✓ | Computer Science, Year 3 |
| `usr_002` | Eric Mugisha | clubLead | ✗ | Business Admin, Year 2 |
| `usr_003` | Grace Uwase | student | ✓ | Medicine, Year 4 |
| `usr_004` | Patrick Nkurunziza | student | ✗ | Electrical Eng., Year 1 |
| `usr_005` | System Administrator | admin | ✓ | Administration |

#### Clubs

| ID | Name | Category | Verified |
|---|---|---|---|
| `clb_001` | Tech Innovators | tech | ✓ |
| `clb_002` | Entrepreneurs Hub | business | ✓ |
| `clb_003` | Health & Wellness Circle | social | ✗ |

#### Events

| ID | Title | Category | Date |
|---|---|---|---|
| `evt_001` | Rwanda Dev Summit 2024 | tech | Dec 5, 2024 |
| `evt_002` | Startup Pitch Night | career | Dec 12, 2024 |
| `evt_003` | Inter-Campus Hackathon | academic | Jan 10–12, 2025 |
| `evt_004` | Mental Health Awareness Week | social | Nov 25–29, 2024 |
| `evt_005` | End of Year Gala | cultural | Dec 20, 2024 |

### Lookup helpers

| Method | Returns | Description |
|---|---|---|
| `getUserById(id)` | `UserModel?` | Find a user by their ID string |
| `getUserByEmail(email)` | `UserModel?` | Find a user by email address |
| `login(email, password)` | `UserModel?` | Authenticate — returns user or null |
| `getEventById(id)` | `EventModel?` | Find an event by ID |
| `getClubById(id)` | `ClubModel?` | Find a club by ID |
| `getPostsByUser(userId)` | `List<PostModel>` | All posts authored by a user |
| `getEventsByUser(userId)` | `List<EventModel>` | Events a user is attending |
| `getNotificationsForUser(userId)` | `List<NotificationModel>` | All notifications for a user |
| `getThreadByParticipants(uid1, uid2)` | `ChatThreadModel?` | DM thread between two users |

### Usage examples

#### Fetch a user profile

```dart
final user = DummyDatabase.getUserById('usr_001');

print(user?.fullName);               // Aline Umuhoza
print(user?.metadata['connects']);   // 87
print(user?.metadata['bio']);        // CS student passionate about AI and design.
print(user?.isOnline);               // true
```

#### Load a user's events

```dart
final events = DummyDatabase.getEventsByUser('usr_001');

for (final event in events) {
  print('${event.title} — ${event.location}');
}
// Rwanda Dev Summit 2024 — Main Auditorium, Kigali Campus
// Startup Pitch Night — Innovation Hub, Block C
// End of Year Gala — Grand Hall, Kigali Campus
```

#### Build a post feed

```dart
final posts = DummyDatabase.getPostsByUser('usr_001');

for (final post in posts) {
  print('${post.type.name}: ${post.content.substring(0, 40)}…');
  print('  ❤  ${post.likeIds.length}  💬 ${post.comments.length}');
}
```

#### Load a chat thread

```dart
final thread = DummyDatabase.getThreadByParticipants('usr_001', 'usr_002');

for (final msg in thread?.messages ?? []) {
  final sender = DummyDatabase.getUserById(msg.senderId);
  print('${sender?.username}: ${msg.content}');
}
// eric.mugisha: Hey Aline, are you coming to the pitch night?
// aline.umuhoza: Yes definitely! Already registered.
// eric.mugisha: Amazing! See you there.
```

#### Get unread notifications

```dart
final allNotifs = DummyDatabase.getNotificationsForUser('usr_001');
final unread = allNotifs.where((n) => !n.isRead).toList();

print('${unread.length} unread notifications'); // 3 unread notifications
```

#### Look up a club and its members

```dart
final club = DummyDatabase.getClubById('clb_001');

print(club?.name);        // Tech Innovators
print(club?.isVerified);  // true

final members = club?.memberIds
    .map(DummyDatabase.getUserById)
    .whereType<UserModel>()
    .toList() ?? [];

for (final member in members) {
  print('  • ${member.fullName}');
}
// • Aline Umuhoza
// • Eric Mugisha
// • Patrick Nkurunziza
```

> **Security note:** The seed data includes plaintext passwords (e.g. `Aline@2024`). These exist solely for local development and must never be shipped in production code.

---

## 5. Session Management

`lib/data/session.dart` is a static singleton that holds the currently logged-in user for the duration of the app's lifetime. It wraps `DummyDatabase.login` so the rest of the app only ever interacts with `Session`.

```dart
import 'package:formative_assignment1/data/session.dart';
```

### Session class

```dart
// lib/data/session.dart

import 'dummy_database.dart';

class Session {
  static UserModel? currentUser;

  static void login(String email, String password) {
    currentUser = DummyDatabase.login(email, password);
  }

  static void logout() {
    currentUser = null;
  }

  static bool get isLoggedIn => currentUser != null;
}
```

| Member | Type | Description |
|---|---|---|
| `Session.currentUser` | `UserModel?` | The signed-in user, or `null` if not logged in |
| `Session.login(email, password)` | `void` | Looks up credentials in `DummyDatabase` and sets `currentUser` |
| `Session.logout()` | `void` | Clears `currentUser` |
| `Session.isLoggedIn` | `bool` | Convenience getter — `true` when `currentUser != null` |

### Login screen integration

Call `Session.login()` when the user submits their credentials, then check `isLoggedIn` to decide whether to navigate:

```dart
ElevatedButton(
  onPressed: () {
    Session.login(
      emailController.text,
      passwordController.text,
    );

    if (Session.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  },
  child: const Text('Sign in'),
)
```

> Use `pushReplacementNamed` (not `pushNamed`) so the back button cannot return to the login screen after a successful sign-in.

### Accessing the current user anywhere in the app

Because `currentUser` is a static field, you can read it from any widget without passing it down the tree:

```dart
// In any widget's build method
final user = Session.currentUser;

Text('Welcome, ${user?.fullName ?? 'Guest'}')
Text('${user?.department} · ${user?.yearOfStudy}')
Image.network(user?.avatarUrl ?? '')
```

### Guarding routes

Wrap sensitive screens with a redirect when the session is not active:

```dart
@override
void initState() {
  super.initState();
  if (!Session.isLoggedIn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}
```

### Logout

Call `Session.logout()` from a settings screen or menu item, then navigate back to the login screen:

```dart
Session.logout();
Navigator.pushReplacementNamed(context, '/login');
```

### Test credentials (seed data)

| Email | Password | Role |
|---|---|---|
| `aline.umuhoza@kigali.edu` | `Aline@2024` | student |
| `eric.mugisha@kigali.edu` | `Eric@2024` | clubLead |
| `grace.uwase@kigali.edu` | `Grace@2024` | student |
| `patrick.nkurunziza@kigali.edu` | `Patrick@2024` | student |
| `admin@kigali.edu` | `Admin@SuperSecure99` | admin |

---

## 6. Quick Reference

### Most-used tokens

```dart
// Colors
AppColors.primary        // #4648D4 — buttons, active
AppColors.scaffoldBg     // #F5F6FF — page background
AppColors.textDark       // #131B2E — headings
AppColors.textMedium     // #464554 — body
AppColors.success        // #00885D — online, positive
AppColors.cardBorder     // #EAEDFF — dividers

// Text styles
AppTextStyles.headingLarge   // 24/600 — screen title
AppTextStyles.headingSmall   // 16/600 — card title
AppTextStyles.bodyMedium     // 14/400 — body copy
AppTextStyles.caption        // 12/400 — timestamps

// Spacing
AppSpacing.sm   //  8 — tight gap
AppSpacing.lg   // 16 — standard gap
AppSpacing.xl   // 24 — section gap / card padding

// Radius
AppRadius.card    // 16
AppRadius.button  // 12
AppRadius.avatar  // 9999 (circle)

// Gradient
AppGradients.heroBanner  // indigo → crimson
```

### Most-used database & session calls

```dart
// Session
Session.login(email, password)  // sets Session.currentUser
Session.isLoggedIn               // bool
Session.currentUser              // UserModel?
Session.logout()                 // clears currentUser

// Database — helpers
DummyDatabase.getUserById(id)
DummyDatabase.getPostsByUser(userId)
DummyDatabase.getEventsByUser(userId)
DummyDatabase.getNotificationsForUser(userId)
DummyDatabase.getClubById(id)
DummyDatabase.getThreadByParticipants(uid1, uid2)

// Database — raw lists
DummyDatabase.users
DummyDatabase.events
DummyDatabase.clubs
DummyDatabase.posts
DummyDatabase.chatThreads
DummyDatabase.notifications
```

---

*formative_assignment1 · Flutter Campus Social App · June 2026*
