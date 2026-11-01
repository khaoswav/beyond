import SwiftUI

struct PublicProfileView: View {
    @EnvironmentObject private var store: BeyondStore

    let name: String
    let handle: String
    let detail: String
    let symbol: String

    private var normalizedHandle: String {
        handle.trimmingCharacters(in: CharacterSet(charactersIn: "@"))
    }

    private var userPosts: [SocialPost] {
        store.posts(for: normalizedHandle)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 22) {
                    Circle()
                        .fill(Color(uiColor: .tertiarySystemFill))
                        .frame(width: 92, height: 92)
                        .overlay {
                            Image(systemName: symbol)
                                .font(.system(size: 38))
                                .foregroundStyle(.secondary)
                        }

                    HStack {
                        statistic(userPosts.count.formatted(), title: "Gönderi")
                        Spacer()
                        statistic("—", title: "Takipçi")
                        Spacer()
                        statistic("—", title: "Takip")
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(name).font(.headline.weight(.semibold))
                    Text(handle).font(.subheadline).foregroundStyle(.secondary)
                    Text(detail).font(.subheadline)
                }

                Button {
                    store.toggleFollow(handle: handle, displayName: name)
                } label: {
                    Text(store.isFollowing(handle) ? "Takiptesin" : "Takip et")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(store.isFollowing(handle) ? Color.primary : Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(
                            store.isFollowing(handle) ? Color(uiColor: .secondarySystemBackground) : Color.accentColor,
                            in: RoundedRectangle(cornerRadius: 11, style: .continuous)
                        )
                }
                .buttonStyle(.plain)

                Divider()

                HStack {
                    Image(systemName: "square.grid.3x3")
                    Text("Gönderiler").font(.subheadline.weight(.semibold))
                    Spacer()
                }

                if userPosts.isEmpty {
                    ContentUnavailableView(
                        "Henüz gönderi yok",
                        systemImage: "photo",
                        description: Text("Bu kullanıcının paylaşımları burada görünecek.")
                    )
                    .padding(.vertical, 28)
                } else {
                    ForEach(userPosts) { post in
                        PostCard(post: post)
                    }
                }
            }
            .padding(.top, 18)
        }
        .scrollIndicators(.hidden)
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statistic(_ value: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title3.weight(.semibold))
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(minWidth: 54)
    }
}
