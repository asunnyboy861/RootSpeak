import SwiftUI
import SwiftData
import PhotosUI

struct CardCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var frontText = ""
    @State private var backText = ""
    @State private var phoneticText = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isRecordingFront = false
    @State private var isRecordingBack = false
    @State private var frontAudioFile: String?
    @State private var backAudioFile: String?
    @State private var audioEngine = AudioEngine()
    let deck: Deck

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    frontCardSection
                    backCardSection
                    phoneticSection
                    imageSection
                    saveButton
                }
                .padding()
            }
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var frontCardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("INDIGENOUS WORD")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("Enter word in indigenous language", text: $frontText)
                .textFieldStyle(.roundedBorder)
                .font(.title3)

            HStack {
                Button {
                    if isRecordingFront {
                        frontAudioFile = audioEngine.stopRecording()
                        isRecordingFront = false
                    } else {
                        do {
                            try audioEngine.startRecording(to: "front_\(UUID().uuidString)")
                            isRecordingFront = true
                        } catch { }
                    }
                } label: {
                    Label(
                        isRecordingFront ? "Stop Recording" : "Record Pronunciation",
                        systemImage: isRecordingFront ? "stop.circle.fill" : "mic.circle"
                    )
                    .foregroundStyle(isRecordingFront ? .red : .accentColor)
                }

                if let file = frontAudioFile {
                    Button { try? audioEngine.play(fileName: file) } label: {
                        Label("Play", systemImage: "play.circle")
                    }
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var backCardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ENGLISH TRANSLATION")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("Enter English translation", text: $backText)
                .textFieldStyle(.roundedBorder)
                .font(.title3)

            HStack {
                Button {
                    if isRecordingBack {
                        backAudioFile = audioEngine.stopRecording()
                        isRecordingBack = false
                    } else {
                        do {
                            try audioEngine.startRecording(to: "back_\(UUID().uuidString)")
                            isRecordingBack = true
                        } catch { }
                    }
                } label: {
                    Label(
                        isRecordingBack ? "Stop Recording" : "Record English",
                        systemImage: isRecordingBack ? "stop.circle.fill" : "mic.circle"
                    )
                    .foregroundStyle(isRecordingBack ? .red : .accentColor)
                }

                if let file = backAudioFile {
                    Button { try? audioEngine.play(fileName: file) } label: {
                        Label("Play", systemImage: "play.circle")
                    }
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var phoneticSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PRONUNCIATION GUIDE")
                .font(.caption)
                .foregroundStyle(.secondary)
            TextField("e.g., yah-ah-TAY", text: $phoneticText)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("IMAGE (OPTIONAL)")
                .font(.caption)
                .foregroundStyle(.secondary)
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Add Photo or Drawing", systemImage: "photo.on.rectangle")
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var saveButton: some View {
        Button {
            let card = Card(frontText: frontText, backText: backText)
            card.phoneticText = phoneticText.isEmpty ? nil : phoneticText
            card.audioFileName = frontAudioFile
            card.backAudioFileName = backAudioFile
            card.deck = deck
            card.sortOrder = deck.cards.count
            deck.cards.append(card)
            deck.cardCount += 1
            deck.updatedAt = Date()
            try? modelContext.save()
            dismiss()
        } label: {
            Text("Save Card")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(frontText.isEmpty || backText.isEmpty)
    }
}

#Preview {
    CardCreationView(deck: Deck(title: "Sample", languageName: "Navajo"))
        .modelContainer(for: [Language.self, Deck.self, Card.self, Review.self, Progress.self])
}
