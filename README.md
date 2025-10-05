# 🧠 Smart Quiz

**Smart Quiz** is a role-based Flutter application designed to provide a complete quiz experience for both **Teachers (Admins)** and **Students (Users)**.  
It follows a **Clean Architecture** structure (Presentation / Domain / Data) with strong separation of concerns, reactive state management (BLoC), and dependency injection (GetIt).

---

## 🚀 Overview

- **Project Name:** Smart Quiz  
- **Purpose:**  
  A quiz platform that allows:
  - **Teachers/Admins:** to manage categories, quizzes, and questions, as well as view statistics.
  - **Students/Users:** to browse quizzes, play with timers, view results, and track progress.

- **Technologies Used:**
  - Flutter & Dart
  - BLoC / Cubit (flutter_bloc)
  - Dio (network requests)
  - GetIt (dependency injection)
  - Dartz (functional programming)
  - Equatable (state equality)
  - Flutter Secure Storage & Shared Preferences
  - App Links (deep linking)
  - Google Fonts & Material Design

---

## ✨ Key Features

- Role-based access: Teacher/Admin vs Student/User.  
- Full CRUD for **categories, quizzes, and questions** (Admin panel).  
- Timer-based quiz gameplay for students.  
- Real-time quiz results and statistics for teachers.  
- Authentication flow with JWT token validation.  
- Deep linking to access content directly.  
- Responsive design for all devices.  
- Centralized theme and consistent UI components.  

---

## 🧩 Architecture Overview

Smart Quiz is built following a **Clean Architecture** approach, organized into three main layers:

### 1. **Presentation Layer**
- Contains **UI (Screens, Widgets)** and **State Management (BLoC/Cubit)**.
- Handles user input and displays UI updates based on BLoC states.
- Example:  
  - `auth_bloc.dart`, `quiz_user_bloc.dart`, `category_admin_bloc.dart`, `timer_bloc.dart`.

### 2. **Domain Layer**
- Defines **Entities**, **Repositories (abstract)**, and **UseCases** (application logic).  
- Contains no Flutter or external dependencies.
- Example: `login_usecase.dart`, `get_all_categories_usecase.dart`.

### 3. **Data Layer**
- Handles actual data retrieval (network, local storage).
- Converts between **Models (JSON)** and **Entities**.
- Example:  
  - `auth_remote_datasource.dart` (Dio API calls)  
  - `auth_repository_impl.dart` (implements domain repository)

---

## 🧠 App Flow

1. The app starts in `main.dart`, initializing the **Service Locator** and **AppLinksManager**.
2. The app registers all required Blocs and dependencies.
3. `AuthGate` decides the entry screen:
   - If **Authenticated**, user is routed based on their role:
     - Teacher → `AdminHomeScreen`
     - Student → `UserHomeScreen`
   - If **Unauthenticated**, shows `LoginScreen`.
4. UI actions trigger Bloc events → handled by UseCases → Repositories → DataSources → emit new states to the UI.

---

## 🗂️ Folder Structure

<img width="479" height="680" alt="image" src="https://github.com/user-attachments/assets/911351ae-96b4-4fbc-bfc3-eb4f20ea24c5" />


---

## ⚙️ Technical Details

### 🔹 State Management
- Managed using **flutter_bloc** and **Cubit**.
- Each feature has its own Bloc for scalability.
- Example:  
  - `AuthBloc` → handles login/register/reset password.  
  - `QuizUserBloc` → handles quiz retrieval and submission.  
  - `TimerBloc` → uses a custom `Ticker` stream for countdown timers.

### 🔹 Networking
- Uses **Dio** for HTTP requests.
- Centralized API endpoints and error models.
- `Failure` and `ErrorMessageModel` used for safe error handling.
- Returns `Either<Failure, T>` from repositories using **Dartz**.

### 🔹 Dependency Injection
- Implemented with **GetIt** (`service_locator.dart`).
- Registers:
  - Data sources
  - Repositories
  - Use cases
  - Blocs

### 🔹 Local Storage & Security
- **flutter_secure_storage** → stores sensitive data (JWT tokens).
- **shared_preferences** → stores small local settings.
- **jwt_decoder** → decodes and validates tokens.

### 🔹 Deep Linking
- Managed with `AppLinksManager` to handle in-app routing from external links.

### 🔹 Theming & UI
- Unified design with **AppTheme** using `Material` + `GoogleFonts`.
- Reusable widgets for cards, quiz elements, forms, and buttons.

---

## 🧩 Main Features by Role

### 👩‍🏫 Admin (Teacher)
- Add, edit, delete, and view:
  - Categories
  - Quizzes
  - Questions
- View statistics dashboard.
- Search quizzes and manage quiz data.

### 👨‍🎓 User (Student)
- Browse quiz categories.
- Search for quizzes by keyword.
- Take quizzes with timers.
- See quiz results instantly.
- Retry or view correct answers.

---

## 🧠 BLoC Flow (Authentication)
1. User enters credentials and clicks “Login”.
2. `LoginEvent` dispatched to `AuthBloc`.
3. `AuthBloc` calls `LoginUseCase`.
4. `LoginUseCase` interacts with `AuthRepository`.
5. `AuthRepository` calls `AuthRemoteDataSource` (via Dio).
6. API response parsed → success or failure returned.
7. `AuthBloc` emits `Authenticated` or `AuthError` state.
8. `AuthGate` routes the user accordingly.
