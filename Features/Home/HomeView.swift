import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BEYONDTheme.Spacing.spacious) {
                    storiesSection
                    feedPlaceholder
                }
                .padding(.vertical, BEYONDTheme.Spacing.standard)
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("BEYOND")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {} label: {
                        Image(systemName: "heart")
                    }
                    .accessibilityLabel("Bildirimler")
                }
            }
        }
    }

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: BEYONDTheme.Spacing.standard) {
            Text("Hikâyeler")
                .font(.headline)
                .padding(.horizontal, BEYONDTheme.Spacing.standard)

            ScrollView(.horizontal) {
                HStack(spacing: BEYONDTheme.Spacing.standard) {
                    storyItem(title: "Hikâyen", isAdd: true)
                    storyItem(title: "Deniz")
                    storyItem(title: "Mert")
                    storyItem(title: "Ece")
                    storyItem(title: "Ada")
                }
                .padding(.horizontal, BEYONDTheme.Spacing.standard)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func storyItem(title: String, isAdd: Bool = false) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(BEYONDTheme.Colors.surface)
                    .frame(width: 64, height: 64)
                    .overlay {
                        Image(systemName: isAdd ? "plus" : "person.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                    .overlay {
                        Circle().strokeBorder(.quaternary, lineWidth: 1)
                    }

                if isAdd {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 20, height: 20)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .overlay(Circle().strokeBorder(Color(uiColor: .systemBackground), lineWidth: 2))
                }
            }

            Text(title)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 68)
        }
        .accessibilityElement(children: .combine)
    }

    private var feedPlaceholder: some View {
        VStack(spacing: BEYONDTheme.Spacing.standard) {
            Image(systemName: "sparkles")
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(.secondary)

            Text("Akışın burada başlayacak")
                .font(.headline)

            Text("Takip ettiğin kişilerin paylaşımları burada görünecek.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 56)
        .padding(.horizontal, BEYONDTheme.Spacing.standard)
    }
}
