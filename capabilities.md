# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- Audio recording (microphone access) for pronunciation recording
- Audio playback for pronunciation listening
- Photo library access for card images
- CloudKit sync for cross-device data
- User Notifications for practice reminders
- No HealthKit, no Location, no Siri, no Apple Watch

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| Microphone (Audio Recording) | Required | Info.plist NSMicrophoneUsageDescription |
| Photo Library | Required | Info.plist NSPhotoLibraryUsageDescription |
| User Notifications | Required | Info.plist permission request |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| CloudKit (iCloud) | Pending | 1. Open Xcode > Signing & Capabilities > + Capability > iCloud 2. Check CloudKit checkbox 3. Create or select CloudKit container: iCloud.com.zzoutuo.RootSpeak 4. Xcode will generate entitlements file automatically |

## No Configuration Needed
- HealthKit: Not applicable
- Location Services: Not applicable
- Siri: Not applicable
- Apple Watch: Not applicable
- Camera: Using PhotosUI picker (no direct camera access needed)
- Background Modes: Not needed (local notifications only)
- Push Notifications: Using local UserNotifications only
- In-App Purchase: Will be configured in Phase 3 based on price.md

## Verification
- Build succeeded after configuration: Pending
- All entitlements correct: Pending
