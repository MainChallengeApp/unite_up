# Dare U - Life Improvement Challenge App

A beautiful, modern Flutter application that helps users improve their lives through daily challenges. Transform your life one challenge at a time!

## 🎯 Features

### **Goal Selection**
- Choose from predefined life improvement goals:
  - 🏥 Become Healthier
  - 👥 Improve Social Skills
  - 🧠 Become More Intelligent
  - 💪 Get Physically Fit
  - 🎨 Boost Creativity
  - ⚡ Increase Productivity
  - 🧘 Practice Mindfulness
  - ⭐ Custom Goal

### **Daily Challenges**
- Receive 3 personalized challenges daily based on your goal
- Challenges come in 3 difficulty levels:
  - 🌱 Easy
  - 🌿 Medium
  - 🌳 Hard
- Select one challenge to complete each day

### **Progress Tracking**
- Submit your progress with notes
- Upload proof with images, videos, or files (mocked for demo)
- Track your journey through an event history timeline

### **Event History**
- All interactions stored in a beautiful chat-like interface
- See your goal selection
- View daily challenge offers
- Track accepted challenges
- Review progress submissions
- Celebrate completed challenges

### **Theme Modes**
- Light Mode, Dark Mode, and System Default
- Beautiful Material Design 3 UI
- Smooth theme transitions

## 📱 App Flow

1. **First Launch**: Users are greeted with an onboarding screen to select their goal
2. **Daily Challenges**: App presents 3 challenges based on the selected goal
3. **Accept Challenge**: User selects one challenge to complete
4. **Submit Progress**: User uploads progress with optional media attachments
5. **Completion**: Challenge is marked as complete, ready for next day!

## 🏗️ Project Structure

```
lib/
├── main.dart                           # App entry point with routing
├── models/
│   ├── goal.dart                       # Goal categories and model
│   ├── challenge.dart                  # Challenge model with difficulty
│   ├── progress_entry.dart             # Progress tracking model
│   └── event.dart                      # Event system for history
├── pages/
│   ├── onboarding_page.dart            # Goal selection onboarding
│   ├── chat_page.dart                  # Main event history timeline
│   └── settings_page.dart              # Settings with theme toggle
├── providers/
│   ├── app_state_provider.dart         # App state management
│   └── theme_provider.dart             # Theme state management
├── services/
│   └── challenge_service.dart          # Challenge generation service
├── theme/
│   └── app_theme.dart                  # App theme configurations
└── widgets/
    ├── event_card.dart                 # Main event router widget
    ├── goal_selected_card.dart         # Goal selection event card
    ├── challenges_offered_card.dart    # Daily challenges display card
    ├── challenge_accepted_card.dart    # Challenge acceptance card
    ├── progress_submitted_card.dart    # Progress submission card
    ├── challenge_completed_card.dart   # Challenge completion card
    ├── ai_message_card.dart            # AI message bubble
    ├── user_message_card.dart          # User message bubble
    └── progress_dialog.dart            # Progress submission dialog
```

## 🎨 Design Highlights

- ✨ Clean, minimalistic, modern UI
- 🎯 Gamified challenge system
- 📊 Visual progress tracking
- 🎭 Beautiful card-based layouts
- 🌈 Indigo/purple color scheme
- 📱 Responsive and adaptive design
- 🔄 Smooth animations and transitions

## 🚀 Getting Started

1. **Install dependencies:**
```bash
flutter pub get
```

2. **Run the app:**

For web (accessible from any device on your network):
```bash
flutter run -d chrome --web-hostname 0.0.0.0 --web-port 8080
```

Then access from your phone at: `http://YOUR_MAC_IP:8080`

For iOS (if device is connected):
```bash
flutter run -d ios
```

For Android:
```bash
flutter run -d android
```

## 📦 Dependencies

- **provider**: State management for app state and themes
- **Material Design 3**: Modern, beautiful UI components

## 💡 Key Concepts

### Event-Driven Architecture
All user interactions and system events are stored as events in a timeline, creating a comprehensive history of the user's improvement journey.

### Mocked Data
All challenges and file uploads are mocked for demonstration purposes. In a production version, this would integrate with:
- Backend API for challenge generation
- File storage for media uploads
- User authentication
- Progress analytics

### Responsive Design
The app adapts beautifully to different screen sizes and orientations, providing an excellent experience on phones, tablets, and web browsers.

## 🎮 Challenge Categories

Each goal category has 8+ unique challenges that are randomly presented to users daily, ensuring variety and sustained engagement.

---

**Built with ❤️ using Flutter and Material Design 3**

*Dare yourself to improve, one challenge at a time! 🚀*
