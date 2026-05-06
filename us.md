# RootSpeak - iOS Development Guide

## Executive Summary

RootSpeak is an indigenous language flashcard creator and study app designed for cultural preservation and language revitalization. It empowers indigenous community members, language teachers, elders, and families to create custom flashcards with native audio pronunciation, images, and phonetic guides, then study them using the scientifically-proven FSRS-6 spaced repetition algorithm.

**Product Vision**: Every indigenous community deserves accessible, culturally-sensitive tools to preserve and revitalize their ancestral languages. RootSpeak puts creation power in the hands of the community, not developers.

**Target Audience**: Indigenous community members (learners), language teachers/elders, tribal language programs, academic linguists, general language enthusiasts, and families with indigenous heritage across the US, Canada, Australia, and New Zealand.

**Key Differentiators**:
- Community-driven content creation (not developer-locked)
- Native audio recording by fluent speakers (not text-to-speech)
- FSRS-6 spaced repetition (state-of-the-art algorithm)
- Offline-first with optional CloudKit sync
- Culturally-sensitive design with earth-tone aesthetics
- Generous free tier that never paywalls cultural tools

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Anki (iOS) | Powerful SRS, vast community, cross-platform | $24.99 one-time, complex UI, no audio recording, not culturally designed | Free tier, built-in audio recording, culturally-themed UI, FSRS-6 (newer algorithm) |
| Quizlet | Polished UI, large user base, gamification | $35.99/year, no custom audio for indigenous languages, generic design, no community creation | Community content creation, native audio, indigenous-focused, lower price |
| AlgoApp (Flashcards) | FSRS support, AI generation, cross-platform sync | Generic design, AI-generated content not suitable for indigenous languages, no cultural sensitivity | Community-driven content, audio by native speakers, culturally-sensitive design |
| Cherokee Nation Dictionary | Free, Cherokee-specific, audio support | Dictionary only (no flashcard/study features), fixed content, no community contribution | Full study system with FSRS, custom flashcard creation, community sharing |
| Lakota Vocab Builder | Free, indigenous-focused | Limited content, broken audio, no custom creation, no SRS | Working audio recording, FSRS scheduling, unlimited custom content |

## Apple Design Guidelines Compliance

- **Clarity**: Clean, uncluttered interface with clear visual hierarchy. Earth-tone color palette provides warmth without distraction. Large touch targets (44x44pt minimum) for accessibility.
- **Consistency**: Standard iOS navigation patterns (TabView, NavigationStack, Sheets). System fonts (SF Pro + New York serif). SF Symbols for all icons.
- **Deference**: Content-first design. Flashcards dominate the screen. UI elements recede using .ultraThinMaterial backgrounds.
- **Depth**: Layered card design with shadows. Spring animations for card flips. Progress indicators provide spatial context.
- **Accessibility**: VoiceOver labels on all interactive elements. Dynamic Type support. High contrast mode. Reduce motion support for card animations.
- **Liquid Glass (iOS 26 Ready)**: Use .ultraThinMaterial for card backgrounds. Translucent elements with depth. Floating tab bar design.

## Technical Architecture

- **Language**: Swift 6.0
- **Framework**: SwiftUI (primary), AVFoundation (audio), PhotosUI (images)
- **Data**: SwiftData with @Model macros, CloudKit sync via NSPersistentCloudKitContainer
- **Spaced Repetition**: FSRS-6 algorithm (custom implementation, MIT-compatible)
- **Audio**: AVAudioRecorder + AVAudioPlayer (native, no third-party)
- **Image**: PhotosUI + Vision Framework (on-device)
- **Cloud**: CloudKit (free, privacy-first, no server costs)
- **Notifications**: UserNotifications (practice reminders)
- **Analytics**: None (privacy-first for indigenous communities)

## Module Structure

```
RootSpeak/
├── RootSpeak/
│   ├── RootSpeakApp.swift
│   ├── Views/
│   │   ├── Home/
│   │   │   └── HomeView.swift
│   │   ├── Decks/
│   │   │   ├── DeckListView.swift
│   │   │   ├── DeckDetailView.swift
│   │   │   └── DeckCreationView.swift
│   │   ├── Cards/
│   │   │   ├── CardCreationView.swift
│   │   │   └── CardDetailView.swift
│   │   ├── Study/
│   │   │   └── StudySessionView.swift
│   │   ├── Statistics/
│   │   │   └── StatisticsView.swift
│   │   └── Settings/
│   │       ├── SettingsView.swift
│   │       └── ContactSupportView.swift
│   ├── ViewModels/
│   │   ├── StudyViewModel.swift
│   │   └── StatisticsViewModel.swift
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
│   └── Assets.xcassets/
├── RootSpeakTests/
└── RootSpeakUITests/
```

## Implementation Flow

1. Set up SwiftData models (Language, Deck, Card, Review, Progress) with relationships
2. Implement FSRS-6 scheduler service with all rating calculations
3. Build AudioEngine service (record + playback) using AVFoundation
4. Create HomeView with daily review prompt and streak display
5. Build DeckListView with language filtering and search
6. Build DeckDetailView showing cards and progress
7. Build CardCreationView with text, audio, image, phonetic input
8. Build StudySessionView with card flip, audio play, FSRS rating
9. Build StatisticsView with heatmap, streak, retention charts
10. Build SettingsView with policy links, iCloud toggle, contact support
11. Build ContactSupportView with feedback form
12. Integrate CloudKit sync for decks and cards
13. Add UserNotifications for daily practice reminders
14. Test on iPhone XS Max and iPad Pro 13-inch (M4) simulators
15. Generate app icon and configure Asset Catalog

## UI/UX Design Specifications

- **Color Scheme**: Earth tones - Terracotta (#C45B28), Sage (#8B9E6B), Sandstone (#D4A574), Slate (#4A5568), Cream (#FFF8F0)
- **Dark Mode**: Warm dark palette (#1A1614 background), full support
- **Typography**: SF Pro (system) for UI text, New York (serif) for indigenous words
- **Corner Radius**: 16pt cards, 12pt buttons, 24pt modals
- **Layout**: .ultraThinMaterial card backgrounds, 24pt spacing between sections
- **Animations**: Subtle spring animations (0.4s), no bouncy/exaggerated effects
- **iPad**: Content max width 720pt with .frame(maxWidth: .infinity) centering
- **Icons**: SF Symbols 5 (filled variants)

## Code Generation Rules

- MVVM pattern with @Observable (Swift 6.0)
- SwiftData for persistence, no third-party ORM
- Offline-first: all features work without network
- Swift 6.0 strict concurrency
- No force unwraps in production code
- Use async/await, not Combine
- Use #Preview macros, not PreviewProvider
- All views support Dynamic Type and VoiceOver
- All audio stored as .m4a (AAC) in app Documents directory
- Images compressed to max 1024px before storage
- Never use "savage", "primitive", "dialect" in UI or code
- Use "indigenous" or specific tribe/nation names
- No analytics that could identify individual users or tribes
- Minimum touch target 44x44pt
- High contrast and Reduce Motion support

## Build & Deployment Checklist

- [ ] Xcode project configured with Bundle ID com.zzoutuo.RootSpeak
- [ ] Deployment target set to iOS 17.0
- [ ] Swift Language Version 5.0+
- [ ] App Icon generated and configured in Asset Catalog
- [ ] Capabilities configured (CloudKit, Notifications, Microphone)
- [ ] Build succeeds on iPhone simulator
- [ ] Build succeeds on iPad simulator
- [ ] All core features tested on both simulators
- [ ] Policy pages deployed to GitHub Pages
- [ ] App Store metadata prepared (keytext.md)
- [ ] Source code pushed to GitHub repository
