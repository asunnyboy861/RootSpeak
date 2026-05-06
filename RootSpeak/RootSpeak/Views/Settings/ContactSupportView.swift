import SwiftUI

struct ContactSupportView: View {
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription", "Data Recovery", "Other"]

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
            }

            Section("Your Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 100)
            }

            Section {
                Button {
                    submitFeedback()
                } label: {
                    if isSubmitting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Submit")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    message = ""
                    email = ""
                    name = ""
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        guard !email.isEmpty, !message.isEmpty else { return }
        isSubmitting = true

        let feedback = FeedbackRequest(
            topic: topic,
            name: name.isEmpty ? nil : name,
            email: email,
            message: message
        )

        guard let url = URL(string: feedbackBackendURL) else {
            isSubmitting = false
            alertMessage = "Failed to submit. Please try again."
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(feedback)
        } catch {
            isSubmitting = false
            alertMessage = "Failed to submit. Please try again."
            showAlert = true
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to submit: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    alertMessage = "Thank you! Your feedback has been submitted successfully."
                } else {
                    alertMessage = "Failed to submit. Please try again."
                }
                showAlert = true
            }
        }.resume()
    }
}

struct FeedbackRequest: Codable {
    let topic: String
    let name: String?
    let email: String
    let message: String
}

private var feedbackBackendURL: String {
    ProcessInfo.processInfo.environment["FEEDBACK_BACKEND_URL"] ?? "https://feedback.example.com/api/submit"
}

#Preview {
    NavigationStack {
        ContactSupportView()
    }
}
