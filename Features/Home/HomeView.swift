import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: BeyondStore
    @State private var isShowingNotifications = false
    @State private var isShowingStoryComposer = false
    @State private var selectedStory: SocialStory?

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
                    Group {
                        if store.activities.isEmpty {
                            ContentUnavailableView(
                                "Şimdilik her şey sakin",
                                systemImage: "heart.text.square",
                                description: Text("Takip hareketlerin burada görünecek.")
                            )
                        } else {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 14) {
                                    ForEach(0..<store.activities.count, id: \.self) { index in
                                        Label(store.activities[index], systemImage: "person.crop.circle.badge.checkmark")
                                            .font(.subheadline)
                                        Divider()
                                    }
                                }
                                .padding(18)
                            }
                        }
                    }
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
            .sheet(isPresented: $isShowingStoryComposer) {
                StoryComposerView()
                    .environmentObject(store)
            }
            .fullScreenCover(item: $selectedStory) { story in
                StoryViewerView(story: story)
            }
        }
    }

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("Hikâyeler")
                    .font(.headline)
                Spacer()
                Text("Günün anlarını paylaş")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 15) {
                    Button {
                        isShowingStoryComposer = true
                    } label: {
                        storyItem(title: "Hikâyen", symbol: "plus", isAdd: true)
                    }
                    .buttonStyle(.plain)

                    ForEach(store.stories) { story in
                        Button {
                            selectedStory = story
                        } label: {
                            storyItem(title: story.authorName, symbol: story.symbol, tint: .orange)
                        }
                        .buttonStyle(.plain)
                    }
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
