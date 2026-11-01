import SwiftUI

private struct ExplorePerson: Identifiable {
    let id: String
    let name: String
    let handle: String
    let detail: String
    let symbol: String

    static let samples: [ExplorePerson] = [
        .init(id: "deniz", name: "Deniz Yılmaz", handle: "@denizyilmaz", detail: "Fotoğraf ve şehir hayatı", symbol: "sun.max.fill"),
        .init(id: "ece", name: "Ece Demir", handle: "@ecedemir", detail: "Yolculuk, tasarım ve günlük hayat", symbol: "camera.fill"),
        .init(id: "mert", name: "Mert Kaya", handle: "@mertkaya", detail: "Müzik ve keşif", symbol: "music.note"),
        .init(id: "ada", name: "Ada Şahin", handle: "@adase", detail: "Doğa ve minimal yaşam", symbol: "leaf.fill")
    ]
}

struct ExploreView: View {
    @EnvironmentObject private var store: BeyondStore
    @State private var searchText = ""
    @State private var selectedScope: SearchScope = .all

    private enum SearchScope: String, CaseIterable, Identifiable {
        case all = "Tümü"
        case people = "Kişiler"
        case posts = "Gönderiler"
        var id: String { rawValue }
    }

    private struct Topic: Identifiable {
        let title: String
        let subtitle: String
        let symbol: String
        var id: String { title }

        static let trending: [Topic] = [
            .init(title: "Şehirden kaçış", subtitle: "Doğa ve yolculuk", symbol: "mountain.2.fill"),
            .init(title: "Gün batımı", subtitle: "Bugünün renkleri", symbol: "sun.horizon.fill"),
            .init(title: "Yeni keşifler", subtitle: "Merakını takip et", symbol: "sparkles"),
            .init(title: "Müzik", subtitle: "Ritmini paylaş", symbol: "music.note")
        ]
    }

    private var normalizedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "tr_TR"))
    }

    private func matches(_ value: String) -> Bool {
        let normalizedValue = value.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "tr_TR"))
        return normalizedValue.localizedCaseInsensitiveContains(normalizedQuery)
    }

    private var matchingPosts: [SocialPost] {
        guard !normalizedQuery.isEmpty else { return store.posts }
        return SocialPost.samples.filter {
            matches($0.authorName) || matches($0.handle) || matches($0.caption) || matches($0.location ?? "")
        }
    }

    private var matchingPeople: [ExplorePerson] {
        guard !normalizedQuery.isEmpty else { return ExplorePerson.samples }
        return ExplorePerson.samples.filter {
            matches($0.name) || matches($0.handle) || matches($0.detail)
        }
    }

    private var isSearching: Bool { !normalizedQuery.isEmpty }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    searchField
                    if isSearching {
                        searchResults
                    } else {
                        trendingSection
                        peopleSection
                        recommendedSection
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color(uiColor: .systemBackground))
            .scrollIndicators(.hidden)
            .navigationTitle("Keşfet")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image("FAMagnifyingGlass").renderingMode(.template)
                .foregroundStyle(.secondary)
            TextField("Kişi, gönderi veya konu ara", text: $searchText)
                .font(.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .accessibilityLabel("Keşfet içinde ara")
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.tertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Aramayı temizle")
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal, 16)
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeading("Şu an keşfedilenler", subtitle: "İlham veren konulara göz at")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Topic.trending) { topic in
                    Button {
                        searchText = topic.title
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: topic.symbol)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 42, height: 42)
                                .background(Color.accentColor.opacity(0.11), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(topic.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                Text(topic.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var peopleSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeading("Tanıyabileceğin kişiler", subtitle: "Yeni insanlarla bağlantı kur")
            VStack(spacing: 4) {
                ForEach(ExplorePerson.samples) { person in
                    PersonSuggestionRow(person: person)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeading("Senin için seçtiklerimiz", subtitle: "Topluluktan öne çıkan paylaşımlar")
            ForEach(store.posts.prefix(2)) { post in
                PostCard(post: post)
            }
        }
    }

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 18) {
            Picker("Arama kapsamı", selection: $selectedScope) {
                ForEach(SearchScope.allCases) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)

            if selectedScope != .posts && !matchingPeople.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Kişiler").font(.headline).padding(.horizontal, 16)
                    ForEach(matchingPeople) { person in
                        PersonSuggestionRow(person: person)
                        .padding(.horizontal, 16)
                    }
                }
            }

            if selectedScope != .people && !matchingPosts.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Gönderiler").font(.headline).padding(.horizontal, 16)
                    ForEach(matchingPosts) { post in
                        PostCard(post: post)
                    }
                }
            }

            let hasResults = (selectedScope != .posts && !matchingPeople.isEmpty)
                || (selectedScope != .people && !matchingPosts.isEmpty)
            if !hasResults {
                ContentUnavailableView.search(text: searchText)
                    .padding(.top, 24)
            }
        }
    }

    private func sectionHeading(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.title3.weight(.bold))
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
    }
}

private struct PersonSuggestionRow: View {
    @EnvironmentObject private var store: BeyondStore
    let person: ExplorePerson

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(uiColor: .tertiarySystemFill))
                .frame(width: 46, height: 46)
                .overlay {
                    Image(systemName: person.symbol)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            VStack(alignment: .leading, spacing: 3) {
                Text(person.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(person.handle + " · " + person.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            Button {
                store.toggleFollow(handle: person.handle, displayName: person.name)
            } label: {
                Text(store.isFollowing(person.handle) ? "Takiptesin" : "Takip et")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(store.isFollowing(person.handle) ? Color.primary : Color.white)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(store.isFollowing(person.handle) ? Color(uiColor: .secondarySystemBackground) : Color.accentColor, in: Capsule())
            }
            .buttonStyle(.plain)
            NavigationLink {
                PublicProfileView(name: person.name, handle: person.handle, detail: person.detail, symbol: person.symbol)
            } label: {
                Image(systemName: "arrow.up.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 34, height: 34)
                    .background(Color(uiColor: .secondarySystemBackground), in: Circle())
            }
            .accessibilityLabel("Profili aç")
        }
        .padding(.vertical, 8)
    }
}
