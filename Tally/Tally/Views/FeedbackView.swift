import SwiftUI

struct FeedbackView: View {
    @Environment(\.tokens) private var T
    @Environment(\.loc) private var L
    @Environment(\.dismiss) private var dismiss

    @State private var message = ""
    @State private var sending = false
    @State private var sent = false
    @State private var errorMsg: String? = nil

    @FocusState private var focusedField: Bool

    private var canSend: Bool {
        message.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10 && !sending
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if sent {
                        successView
                    } else {
                        formView
                    }
                }
                .padding(16)
            }
            .background(T.bg)
            .navigationTitle(L.sendFeedback)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L.cancel) { dismiss() }
                        .foregroundStyle(T.accent)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L.done) { focusedField = false }
                }
            }
        }
    }

    // MARK: - Form

    private var formView: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("MESSAGE")
                        .font(.custom("JetBrainsMono-SemiBold", size: 11))
                        .tracking(0.6)
                        .foregroundStyle(T.textMuted)
                    Spacer()
                    Text("\(message.count)/500")
                        .font(.custom("JetBrainsMono-Regular", size: 11))
                        .foregroundStyle(message.count > 450 ? T.accent : T.textTertiary)
                }

                TextEditor(text: $message)
                    .font(.custom("JetBrainsMono-Regular", size: 15))
                    .foregroundStyle(T.text)
                    .scrollContentBackground(.hidden)
                    .focused($focusedField)
                    .frame(minHeight: 160)
                    .padding(14)
                    .background(T.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TallyRadius.medium))
                    .onChange(of: message) { _, new in
                        if new.count > 500 { message = String(new.prefix(500)) }
                    }
            }

            if let errorMsg {
                Text(errorMsg)
                    .font(.custom("JetBrainsMono-Regular", size: 13))
                    .foregroundStyle(T.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button(action: sendFeedback) {
                HStack(spacing: 8) {
                    if sending {
                        ProgressView().tint(.white).scaleEffect(0.85)
                    } else {
                        Image(systemName: "paperplane.fill").font(.system(size: 15))
                    }
                    Text(sending ? "Sending…" : L.sendFeedback)
                        .font(.custom("JetBrainsMono-SemiBold", size: 16))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(canSend ? T.accent : T.textTertiary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
            }
            .buttonStyle(.plain)
            .disabled(!canSend)

            Text("Min. 10 characters")
                .font(.custom("JetBrainsMono-Regular", size: 11))
                .foregroundStyle(T.textTertiary)
        }
    }

    // MARK: - Success

    private var successView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            ZStack {
                Circle().fill(T.success.opacity(0.12)).frame(width: 80, height: 80)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(T.success)
            }
            VStack(spacing: 8) {
                Text("Thank you!")
                    .font(.custom("JetBrainsMono-SemiBold", size: 22))
                    .foregroundStyle(T.text)
                Text("Your feedback has been sent.")
                    .font(.custom("JetBrainsMono-Regular", size: 15))
                    .foregroundStyle(T.textMuted)
            }
            Button(L.done) { dismiss() }
                .font(.custom("JetBrainsMono-SemiBold", size: 16))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(T.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: TallyRadius.large))
                .buttonStyle(.plain)
                .padding(.top, 20)
        }
    }

    // MARK: - Send via Firestore REST API (with anonymous auth)

    private let projectID = "tally-bec34"
    private let apiKey   = "AIzaSyAkixmRkzzoBaTvxu7-iV5Dle3BES-6Z_M"

    private func sendFeedback() {
        focusedField = false
        sending = true
        errorMsg = nil
        signInAnonymously { token in
            if let token {
                postToFirestore(idToken: token)
            } else {
                // fallback: try without auth (works if Firestore rules allow it)
                postToFirestore(idToken: nil)
            }
        }
    }

    // Step 1 — get Firebase anonymous ID token via Auth REST API
    private func signInAnonymously(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(apiKey)") else {
            completion(nil); return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: ["returnSecureToken": true])

        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["idToken"] as? String else {
                completion(nil); return
            }
            completion(token)
        }.resume()
    }

    // Step 2 — write document to Firestore
    private func postToFirestore(idToken: String?) {
        let urlStr = "https://firestore.googleapis.com/v1/projects/\(projectID)/databases/(default)/documents/feedback?key=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        let info = Bundle.main.infoDictionary
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? "1.0"

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let createdAt = dateFmt.string(from: Date())

        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineID = machineMirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        let deviceName = deviceName(for: machineID)

        let fields: [String: Any] = [
            "message":    ["stringValue": message.trimmingCharacters(in: .whitespacesAndNewlines)],
            "device":     ["stringValue": deviceName],
            "appVersion": ["stringValue": appVersion],
            "createdAt":  ["stringValue": createdAt],
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = idToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["fields": fields])

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                sending = false
                if let error { errorMsg = "Error: \(error.localizedDescription)"; return }
                let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                if (200...299).contains(status) {
                    sent = true
                } else {
                    errorMsg = "Server error (\(status)). Check Firestore rules."
                }
            }
        }.resume()
    }

    private func deviceName(for machineID: String) -> String {
        let map: [String: String] = [
            "iPhone14,4": "iPhone 13 mini", "iPhone14,5": "iPhone 13",
            "iPhone14,2": "iPhone 13 Pro",  "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone15,2": "iPhone 14 Pro",  "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone14,6": "iPhone SE 3",    "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",
            "iPhone16,1": "iPhone 15",      "iPhone16,2": "iPhone 15 Plus",
            "iPhone16,3": "iPhone 15 Pro",  "iPhone16,4": "iPhone 15 Pro Max",
            "iPhone17,1": "iPhone 16",      "iPhone17,2": "iPhone 16 Plus",
            "iPhone17,3": "iPhone 16 Pro",  "iPhone17,4": "iPhone 16 Pro Max",
            "iPhone17,5": "iPhone 16e",
            "i386": "Simulator", "x86_64": "Simulator", "arm64": "Simulator",
        ]
        return map[machineID] ?? UIDevice.current.model
    }
}
