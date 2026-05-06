import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("useCloudKit") private var useCloudKit = false
    @State private var dataManager = DataManager()

    private var supportURL: String {
        "https://asunnyboy861.github.io/RootSpeak/support.html"
    }
    private var privacyURL: String {
        "https://asunnyboy861.github.io/RootSpeak/privacy.html"
    }
    private var termsURL: String {
        "https://asunnyboy861.github.io/RootSpeak/terms.html"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Sync") {
                    Toggle("Enable iCloud Sync", isOn: $useCloudKit)
                    Text("Sync data across all your devices")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Subscription") {
                    NavigationLink {
                        PaywallView()
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.orange)
                            Text("Upgrade to RootSpeak+")
                        }
                    }

                    Button {
                    } label: {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Restore Purchases")
                        }
                    }
                }

                Section("Legal") {
                    Link("Support", destination: URL(string: supportURL)!)
                    Link("Privacy Policy", destination: URL(string: privacyURL)!)
                    Link("Terms of Use", destination: URL(string: termsURL)!)
                }

                Section("Feedback") {
                    NavigationLink(destination: ContactSupportView()) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Contact Support")
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.orange)

                Text("RootSpeak+")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Unlock the full potential of indigenous language learning")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    PaywallFeatureRow(icon: "infinity", text: "Unlimited decks and cards")
                    PaywallFeatureRow(icon: "cloud", text: "CloudKit sync across devices")
                    PaywallFeatureRow(icon: "person.2", text: "Community deck sharing")
                    PaywallFeatureRow(icon: "chart.bar", text: "Advanced statistics")
                    PaywallFeatureRow(icon: "square.and.arrow.up", text: "Export decks as PDF")
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

                VStack(spacing: 12) {
                    Button {
                    } label: {
                        Text("Monthly - $2.99/month")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                    } label: {
                        Text("Yearly - $19.99/year (Save 44%)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                    } label: {
                        Text("Lifetime - $9.99 one-time")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                Text("7-day free trial. Cancel anytime.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("RootSpeak+")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaywallFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
}
