# RootSpeak - Indigenous Language Flashcard Creator

## App Overview
RootSpeak is an iOS app that helps users create, study, and share flashcards for indigenous and endangered languages. It uses the FSRS-6 spaced repetition algorithm to optimize learning retention and supports audio recording for pronunciation preservation.

## Key Features
- Create custom flashcard decks for any indigenous language
- Audio recording for pronunciation capture and playback
- FSRS-6 spaced repetition algorithm for optimal study scheduling
- Study statistics with streak tracking and retention rates
- CloudKit sync across Apple devices (Premium)
- Community deck sharing (Premium)

## Technical Stack
- **Language**: Swift 6.0
- **Framework**: SwiftUI, AVFoundation, PhotosUI
- **Data**: SwiftData with @Model macros
- **Cloud**: CloudKit (privacy-first, no server costs)
- **Spaced Repetition**: FSRS-6 algorithm (custom implementation)
- **Audio**: AVAudioRecorder + AVAudioPlayer (native)

## Monetization
- **Free**: 3 decks, 50 cards per deck, local storage
- **RootSpeak+ Monthly**: $2.99/month
- **RootSpeak+ Yearly**: $19.99/year (44% savings)
- **RootSpeak Community**: $9.99 one-time lifetime

## App Store Information
- **Bundle ID**: com.zzoutuo.RootSpeak
- **Category**: Education
- **Age Rating**: 4+
- **Minimum iOS**: 17.0

## Policy Pages
- Support: https://asunnyboy861.github.io/RootSpeak/support.html
- Privacy: https://asunnyboy861.github.io/RootSpeak/privacy.html
- Terms: https://asunnyboy861.github.io/RootSpeak/terms.html

## Project Structure
```
RootSpeak/
├── RootSpeak/
│   ├── RootSpeakApp.swift
│   ├── ContentView.swift
│   ├── Models/
│   │   ├── Language.swift
│   │   ├── Deck.swift
│   │   ├── Card.swift
│   │   ├── Review.swift
│   │   └── Progress.swift
│   ├── Services/
│   │   ├── FSRSScheduler.swift
│   │   ├── AudioEngine.swift
│   │   └── DataManager.swift
│   └── Views/
│       ├── Home/HomeView.swift
│       ├── Decks/
│       │   ├── DeckListView.swift
│       │   ├── DeckDetailView.swift
│       │   └── DeckCreationView.swift
│       ├── Cards/CardCreationView.swift
│       ├── Study/StudySessionView.swift
│       ├── Statistics/StatisticsView.swift
│       └── Settings/
│           ├── SettingsView.swift
│           └── ContactSupportView.swift
├── us.md
├── price.md
├── capabilities.md
├── icon.md
└── nowgit.md
```

## Development Status
- [x] Project setup and configuration
- [x] Data models (Language, Deck, Card, Review, Progress)
- [x] FSRS-6 spaced repetition scheduler
- [x] Audio recording and playback engine
- [x] Home view with daily review and streak
- [x] Deck management (CRUD)
- [x] Card creation with audio and images
- [x] Study session with rating system
- [x] Statistics dashboard
- [x] Settings with paywall
- [x] Contact support with feedback API
- [ ] CloudKit sync implementation
- [ ] In-app purchase integration
- [ ] Community deck sharing
- [ ] Widget support
