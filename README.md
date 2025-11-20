# AI Chat App

A beautiful, modern, and minimalistic Flutter chat application with AI assistant functionality.

## Features

- 🎨 **Modern UI Design**: Clean and minimalistic interface using Material Design 3
- 💬 **AI Chat Interface**: Beautiful chat bubbles with smooth animations
- 🌓 **Theme Toggle**: Switch between Light, Dark, and System themes
- 📱 **Responsive Design**: Works seamlessly on all screen sizes
- 🎭 **Mock AI Responses**: Simulated AI responses for demonstration

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── chat_message.dart         # Chat message data model
├── pages/
│   ├── chat_page.dart            # Main chat interface
│   └── settings_page.dart        # Settings with theme toggle
├── providers/
│   └── theme_provider.dart       # Theme state management
├── services/
│   └── mock_ai_service.dart      # Mock AI response service
├── theme/
│   └── app_theme.dart            # App theme configurations
└── widgets/
    ├── chat_bubble.dart          # Custom chat bubble widget
    └── chat_input.dart           # Chat input field widget
```

## Dependencies

- **provider**: State management for theme switching
- **flutter_chat_ui**: Beautiful chat UI components
- **uuid**: Generate unique message IDs
- **flutter_svg**: SVG support for icons

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Theme Features

The app supports three theme modes:
- **Light Mode**: Bright and clear interface with indigo accent colors
- **Dark Mode**: Easy on the eyes with dark backgrounds
- **System Default**: Automatically follows your device's theme settings

## UI Highlights

- Custom chat bubbles with user/AI avatars
- Smooth scrolling and animations
- Beautiful card-based settings interface
- Real-time theme switching without restart
- Elegant loading states and empty states

## Screenshots

The app features:
- A clean chat interface with message bubbles
- Settings page with theme selection
- Smooth transitions and animations
- Modern color scheme (Indigo/Purple palette)

---

Built with ❤️ using Flutter
