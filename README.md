# Flutter Employee Directory App

A clean, feature-first Flutter application that allows users to authenticate, view a list of employees, filter them, and manage favorites.

## 🚀 Features

* **Authentication:** Secure login flow with token interception and local storage.
* **Employee Directory:** Fetch, view, and filter employee lists.
* **Favorites:** Mark specific employees as favorites for quick access.
* **Theming & Localization:** Built-in support for dark/light mode switching and multi-language support.
* **Robust UI States:** Global handling for empty states, errors, no-internet connections, and loading shimmers.

## 🛠️ Tech Stack

* **State Management:** Riverpod (using Notifiers and Providers)
* **Networking:** Dio (with custom interceptors for auth)
* **Routing:** Centralized app routing mechanism
* **Local Storage:** Key-Value storage for caching auth and user preferences

## 📂 Project Structure

The project follows a **Feature-Driven Architecture**, separating the app into core utilities and distinct feature modules.

```text
lib/
 ┣ src/
 ┃ ┣ core/          # App-wide shared resources (networking, themes, UI components)
 ┃ ┗ features/      # Isolated feature modules (auth, home, favorite)
 ┗ main.dart        # Application entry point
```

### Core Module (`lib/src/core`)
This directory contains everything shared across multiple features:
* **`config/router`**: Manages app navigation and route definitions.
* **`network`**: Contains the `dio_client` for handling API requests globally.
* **`storage`**: Local storage logic (`key_value_storage`) for caching.
* **`theme`**: App-wide theme provider for light/dark mode.
* **`widgets`**: Reusable UI components like shimmers, error screens, empty states, and offline widgets.

### Features Module (`lib/src/features`)
Each feature is self-contained with its own data and presentation logic.

* **Auth (`/auth`)**: Handles the splash screen, login screen, and authentication repository. Includes local data sources and token interceptors.
* **Home (`/home`)**: The main dashboard of the app. Handles fetching employee data models, the employee list, details screen, and filtering logic via bottom sheets.
* **Favorite (`/favorite`)**: Manages the state and UI for user-favorited items.

## 💻 Getting Started

### Prerequisites
* Flutter SDK (latest stable version)
* Dart SDK

### 📦 Installation

1. Clone the repository:
   ```bash
   git clone <your-repository-url>
   ```

2. Navigate into the project directory:
   ```bash
   cd <your-project-folder>
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

### 🏃‍♂️ Running the App

To run the app on a connected device or emulator, use the following commands:

**Standard Run (Default connected device):**
```bash
flutter run
```

**Run on a specific device:**
```bash
flutter run -d <device_id>
```

**Run using a specific entry point (e.g., for flavors):**
```bash
flutter run -t lib/main.dart
```

### 🛠️ Building for Production

**Build an APK for Android:**
```bash
flutter build apk --release
```

**Build an App Bundle for Google Play:**
```bash
flutter build appbundle --release
```