# 🎬 CineLuxe — Flutter Movie Application

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange)
![Bloc](https://img.shields.io/badge/State%20Management-Cubit-blue)

A modern Flutter movie application that allows users to browse movies, search for titles, view movie details, and discover recommendations through a clean and responsive user experience.

Built with Flutter using Cubit (BLoC), REST APIs, Firebase integration, and a scalable project structure.

---

## 📱 Features

- 🎬 Browse Movies
- 🔍 Search Movies
- 📄 View Movie Details
- 💡 Movie Recommendations
- ⚡ Fast API Integration
- 🔥 Firebase Integration
- 📱 Responsive UI
- 🎨 Modern Design
- 🚀 Smooth Navigation

---

## 📸 Screenshots

### Login & Register Screen

<img width="300" alt="Login Screen" src="https://github.com/user-attachments/assets/3e14ce20-6c4d-436f-a8e8-1a825da9e614" />
<img width="300" alt="Register Screen" src="https://github.com/user-attachments/assets/0a7b7894-a311-4767-be4b-2ba6a31c1be3" />

### Home Screen

<img width="300" alt="Home Screen" src="https://github.com/user-attachments/assets/0c03bf10-0cb9-434d-bb7a-d2b1c3ffeb44" />

### Movie Details Screen

<img width="300" alt="Movie Details Screen" src="https://github.com/user-attachments/assets/0d52c940-353e-41b5-b843-ce187d93556c" />

### Search Screen

<img width="300" alt="Search Screen" src="https://github.com/user-attachments/assets/95f7058e-4d6a-4156-b0d9-d989c54a6ebf" />

---

## 🎥 Demo

Watch a quick walkthrough of the application:


https://github.com/user-attachments/assets/46a8c0b1-0eec-4d43-8882-ebe0ac7f3e8a




---

## 🏗️ Project Structure

```text
lib/
├── api/
│   ├── dio/
│   ├── api_constants.dart
│   └── end_point.dart
│
├── core/
├── data/
├── models/
├── prefs/
├── screens/
├── utils/
├── widgets/
│
├── firebase_options.dart
└── main.dart
```

---

## 🧠 Architecture

The application follows a layered architecture:

```text
Presentation Layer
      ↓
Cubit / BLoC
      ↓
API Layer (Dio)
      ↓
REST API
```

### Benefits

- Clean Code
- Separation of Concerns
- Scalability
- Maintainability
- Easy Testing

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Cubit (BLoC)
- Dio
- Firebase
- REST API
- Shared Preferences

---

## 📦 Packages

| Package | Usage |
|----------|----------|
| flutter_bloc | State Management |
| dio | API Calls |
| shared_preferences | Local Storage |
| firebase_core | Firebase Setup |
| firebase_auth | Authentication |
| cloud_firestore | Database |
| google_sign_in | Google Authentication |
| cached_network_image | Image Caching |

---

## 🔑 API

### Base URL

```dart
https://movies-api.accel.li/api/v2/
```

### Endpoints

```dart
list_movies.json
movie_details.json
movie_suggestions.json
```

---

## 🚀 Getting Started

### Clone Repository

```bash
git clone https://github.com/engkareemmohamed12-max/CineLuxe.git
```

### Install Dependencies

```bash
flutter pub get
```

### Run Project

```bash
flutter run
```

---

## 💼 Skills Demonstrated

- State Management with Cubit
- REST API Integration
- Firebase Integration
- Responsive UI Design
- Layered Architecture
- Error Handling
- Reusable Widgets
- Code Organization

---

## 👨‍💻 Developer

**Karim Mohamed**

### Connect with me

- LinkedIn: [Karim Mohamed](https://www.linkedin.com/in/kareem-mohamed-flutter/)
- GitHub: [engkareemmohamed12-max](https://github.com/engkareemmohamed12-max)
