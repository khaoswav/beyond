import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: BeyondStore
    @State private var isShowingNotifications = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    storiesSection
                        .padding(.bottom, 18)

                    Rectangle()
                        .fill(Color(uiColor: .separator).opacity(0.35))
                        .frame(height: 0.5)

                    ForEach(store.posts) { post in
                        PostCard(post: post)
                    }
                }
                .padding(.top, 8)
            }
            .background(Color(uiColor: .systemBackground))
            .scrollIndicators(.hidden)
            .navigationTitle("BEYOND")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNotifications = true
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(size: 20, weight: .regular))
                    }
                    .accessibilityLabel("Bildirimler")
                }
            }
            .sheet(isPresented: $isShowingNotifications) {
                NavigationStack {
                    ContentUnavailableView(
                        "Şimdilik her şey sakin",
                        systemImage: "heart.text.square",
                        description: Text("Yeni beğeniler ve takip bildirimlerin burada görünecek.")
                    )
                    .navigationTitle("Bildirimler")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Bitti") { isShowingNotifications = false }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("Hikâyeler")
                    .font(.headline)
                Spacer()
                Text("Tümünü gör")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 15) {
                    storyItem(title: "Hikâyen", symbol: "plus", isAdd: true)
                    storyItem(title: "Deniz", symbol: "sun.max.fill", tint: .orange)
                    storyItem(title: "Mert", symbol: "mountain.2.fill", tint: .indigo)
                    storyItem(title: "Ece", symbol: "camera.fill", tint: .pink)
                    storyItem(title: "Ada", symbol: "leaf.fill", tint: .green)
                    storyItem(title: "Can", symbol: "music.note", tint: .purple)
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func storyItem(
        title: String,
        symbol: String,
        isAdd: Bool = false,
        tint: Color = .secondary
    ) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        isAdd
                        ? Color(uiColor: .secondarySystemBackground)
                        : tint.opacity(0.14)
                    )
                    .frame(width: 66, height: 66)
                    .overlay {
                        Circle()
                            .strokeBorder(
                                isAdd ? Color(uiColor: .separator).opacity(0.45) : tint.opacity(0.75),
                                lineWidth: isAdd ? 1 : 2
                            )
                    }
                    .overlay {
                        Image(systemName: symbol)
                            .font(.system(size: 23, weight: .medium))
                            .foregroundStyle(isAdd ? Color.primary : tint)
                    }

                if isAdd {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 21, height: 21)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .overlay {
                            Circle().strokeBorder(Color(uiColor: .systemBackground), lineWidth: 2)
                        }
                }
            }

            Text(title)
                .font(.caption)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .frame(width: 70)
        }
        .accessibilityElement(children: .combine)
    }
}
