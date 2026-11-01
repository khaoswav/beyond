import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("beyond.profile.displayName") private var savedName = "Khaos"
    @AppStorage("beyond.profile.username") private var savedUsername = "khaos"
    @AppStorage("beyond.profile.bio") private var savedBio = "Kendi hikâyeni paylaş."
    @AppStorage("beyond.onboarding.completed") private var hasCompletedOnboarding = false

    @State private var name = ""
    @State private var username = ""
    @State private var bio = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case name
        case username
        case bio
    }

    private var normalizedUsername: String {
        username.lowercased().filter { $0.isLetter || $0.isNumber || $0 == "_" || $0 == "." }
    }

    private var canContinue: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && normalizedUsername.count >= 3
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    VStack(alignment: .leading, spacing: 14) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 64, height: 64)
                            .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 20, style: .continuous))

                        Text("Daha fazlası, burada başlar.")
                            .font(.largeTitle.weight(.bold))
                            .tracking(-0.6)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Kendi alanını oluştur, ilham veren insanları keşfet ve hikâyeni paylaş.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 18)

                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Adın")
                                .font(.subheadline.weight(.semibold))
                            TextField("Nasıl hitap edelim?", text: $name)
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .name)
                        }

                        VStack(alignment: .leading, spacing: 7) {
                            Text("Kullanıcı adın")
                                .font(.subheadline.weight(.semibold))
                            HStack(spacing: 5) {
                                Text("@").foregroundStyle(.secondary)
                                TextField("kullaniciadi", text: $username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .username)
                                    .onChange(of: username) { _, value in
                                        username = value.lowercased().filter { $0.isLetter || $0.isNumber || $0 == "_" || $0 == "." }
                                    }
                            }
                            .padding(11)
                            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 9))
                            Text("En az 3 karakter. Harf, rakam, nokta ve alt çizgi kullanabilirsin.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 7) {
                            Text("Kısa biyografi")
                                .font(.subheadline.weight(.semibold))
                            TextField("Seni anlatan birkaç kelime...", text: $bio, axis: .vertical)
                                .lineLimit(2...4)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .bio)
                        }
                    }

                    Button {
                        savedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        savedUsername = normalizedUsername
                        savedBio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
                        hasCompletedOnboarding = true
                        focusedField = nil
                        dismiss()
                    } label: {
                        Text("BEYOND'a katıl")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 14))
                    .disabled(!canContinue)

                    Text("Bu sürümde profil bilgilerin bu cihazda saklanır. Çevrimiçi hesap oluşturma henüz bağlı değil.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding(24)
            }
            .background(Color(uiColor: .systemBackground))
            .toolbar(.hidden, for: .navigationBar)
        }
        .interactiveDismissDisabled()
        .onAppear {
            name = savedName == "Khaos" ? "" : savedName
            username = savedUsername == "khaos" ? "" : savedUsername
            bio = savedBio == "Kendi hikâyeni paylaş." ? "" : savedBio
        }
    }
}
