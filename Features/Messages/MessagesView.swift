import SwiftUI

private struct Conversation: Identifiable, Hashable {
    let id: String
    let name: String
    let handle: String
    let preview: String
    let time: String
    let symbol: String
    let unread: Bool
}

struct MessagesView: View {
    @State private var searchText = ""
    @State private var selectedConversation: Conversation?

    private let conversations = [
        Conversation(id: "deniz", name: "Deniz Yılmaz", handle: "@denizyilmaz", preview: "Hafta sonu fotoğraflarını gördüm, harika!", time: "12:42", symbol: "sun.max.fill", unread: true),
        Conversation(id: "ece", name: "Ece Demir", handle: "@ecedemir", preview: "Yeni keşfettiğim yeri sana da atayım.", time: "Dün", symbol: "camera.fill", unread: true),
        Conversation(id: "mert", name: "Mert Kaya", handle: "@mertkaya", preview: "Paylaştığın parçayı dinledim.", time: "Pzt", symbol: "music.note", unread: false)
    ]

    private var filtered: [Conversation] {
        guard !searchText.isEmpty else { return conversations }
        return conversations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.handle.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { conversation in
                Button {
                    selectedConversation = conversation
                } label: {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(uiColor: .tertiarySystemFill))
                            .frame(width: 52, height: 52)
                            .overlay {
                                Image(systemName: conversation.symbol)
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(conversation.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(conversation.time)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(conversation.preview)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        if conversation.unread {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Mesajlarda ara")
            .navigationTitle("Mesajlar")
            .navigationDestination(item: $selectedConversation) { conversation in
                ConversationView(conversation: conversation)
            }
        }
    }
}

private struct ConversationView: View {
    let conversation: Conversation
    @State private var draft = ""
    @State private var sentMessages: [String] = []

    private var storageKey: String { "beyond.messages." + conversation.id }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    Text("BEYOND sohbeti")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 20)
                    messageBubble(conversation.preview, isOutgoing: false)
                    ForEach(Array(sentMessages.enumerated()), id: \.offset) { _, message in
                        messageBubble(message, isOutgoing: true)
                    }
                    Text("Bu sohbet şu anda örnek içerik kullanıyor. Gerçek zamanlı mesajlaşma sunucu bağlantısı gerektirir.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 18)
                }
                .padding()
            }
            HStack(spacing: 10) {
                TextField("Mesaj yaz...", text: $draft, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                Button {
                    let message = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !message.isEmpty else { return }
                    sentMessages.append(message)
                    draft = ""
                } label: {
                    Image("FAPaperPlane").renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel("Mesaj gönder")
            }
            .padding()
            .background(.bar)
        }
        .navigationTitle(conversation.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let data = UserDefaults.standard.data(forKey: storageKey),
                  let stored = try? JSONDecoder().decode([String].self, from: data) else { return }
            sentMessages = stored
        }
        .onChange(of: sentMessages) { _, messages in
            guard let data = try? JSONEncoder().encode(messages) else { return }
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func messageBubble(_ text: String, isOutgoing: Bool) -> some View {
        HStack {
            if isOutgoing { Spacer(minLength: 50) }
            Text(text)
                .font(.body)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isOutgoing ? Color.accentColor : Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
                .foregroundStyle(isOutgoing ? Color.white : Color.primary)
            if !isOutgoing { Spacer(minLength: 50) }
        }
    }
}
