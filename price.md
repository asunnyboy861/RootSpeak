# Pricing Configuration

## Monetization Model: Subscription (IAP) + One-Time Purchase

## Subscription Group
- **Group Name**: RootSpeak Premium
- **Group ID**: RootSpeakPremium

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: RootSpeak+ Monthly
- **Product ID**: `com.zzoutuo.RootSpeak.monthly`
- **Price**: $2.99 per month
- **Display Name**: RootSpeak+ Monthly
- **Description**: Unlimited decks, CloudKit sync, sharing
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: RootSpeak+ Yearly
- **Product ID**: `com.zzoutuo.RootSpeak.yearly`
- **Price**: $19.99 per year (44% savings vs monthly)
- **Display Name**: RootSpeak+ Yearly
- **Description**: Unlimited decks, sync, sharing, best value
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: RootSpeak Community
- **Product ID**: `com.zzoutuo.RootSpeak.lifetime`
- **Price**: $9.99 one-time
- **Display Name**: RootSpeak Community
- **Description**: Unlimited decks, sync, sharing forever
- **Localization**: English (US)

## Free Tier Features
- Create up to 3 decks
- Up to 50 cards per deck
- Full audio recording and playback
- FSRS spaced repetition study
- Basic statistics (streak, retention)
- Local storage only

## Premium Features (Subscription + Lifetime)
- Unlimited decks and cards
- CloudKit sync across devices
- Community deck sharing
- Advanced statistics (heatmap, forecast)
- Export decks as PDF
- Priority audio quality (48kHz)
- Widget customization

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to monthly)

## Policy Pages Required
- Support Page: Yes (Must include subscription management info)
- Privacy Policy: Yes
- Terms of Use: Yes (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented
