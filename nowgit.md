# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | RootSpeak |
| **Git URL** | git@github.com:asunnyboy861/RootSpeak.git |
| **Repo URL** | https://github.com/asunnyboy861/RootSpeak |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | Enabled (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/RootSpeak/ | Pending |
| Support | https://asunnyboy861.github.io/RootSpeak/support.html | Pending |
| Privacy Policy | https://asunnyboy861.github.io/RootSpeak/privacy.html | Pending |
| Terms of Use | https://asunnyboy861.github.io/RootSpeak/terms.html | Pending |

Note: Terms of Use required for IAP subscription apps.

## Repository Structure

```
RootSpeak/
├── RootSpeak/                                # iOS App Source Code
│   ├── RootSpeak.xcodeproj/                  # Xcode Project
│   ├── RootSpeak/                            # Swift Source Files
│   │   ├── RootSpeakApp.swift
│   │   ├── ContentView.swift
│   │   ├── Models/
│   │   │   ├── Language.swift
│   │   │   ├── Deck.swift
│   │   │   ├── Card.swift
│   │   │   ├── Review.swift
│   │   │   └── Progress.swift
│   │   ├── Services/
│   │   │   ├── FSRSScheduler.swift
│   │   │   ├── AudioEngine.swift
│   │   │   └── DataManager.swift
│   │   └── Views/
│   │       ├── Home/HomeView.swift
│   │       ├── Decks/
│   │       │   ├── DeckListView.swift
│   │       │   ├── DeckDetailView.swift
│   │       │   └── DeckCreationView.swift
│   │       ├── Cards/CardCreationView.swift
│   │       ├── Study/StudySessionView.swift
│   │       ├── Statistics/StatisticsView.swift
│   │       └── Settings/
│   │           ├── SettingsView.swift
│   │           └── ContactSupportView.swift
│   └── Assets.xcassets/
├── docs/                          # Policy Pages (GitHub Pages source)
│   ├── index.html                 # Landing Page
│   ├── support.html               # Support Page
│   ├── privacy.html               # Privacy Policy
│   └── terms.html                 # Terms of Use (subscription)
├── .github/workflows/
│   └── deploy.yml                 # GitHub Pages deployment
├── us.md                          # English Development Guide
├── keytext.md                     # App Store Metadata
├── capabilities.md                # Capabilities Configuration
├── icon.md                        # App Icon Details
├── price.md                       # Pricing Configuration
└── nowgit.md                      # This File
```
