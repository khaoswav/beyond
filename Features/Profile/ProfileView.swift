import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @AppStorage("beyond.profile.displayName") private var displayName = "Khaos"
    @AppStorage("beyond.profile.username") private var username = "khaos"
    @AppStorage("beyond.profile.bio") private var bio = "Kendi hikâyeni paylaş."
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImageData: Data?
    @State private var isEditingProfile = false

    private let columns = [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    profileHeader
                    profileActions
                    Divider()
                    postSection
                }
                .padding(.top, 12)
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Profili düzenle", systemImage: "pencil") { isEditingProfile = true }
                        ShareLink(item: "BEYOND'da @\(username) profilini keşfet.") {
                            Label("Profili paylaş", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    .accessibilityLabel("Profil menüsü")
                }
            }
            .sheet(isPresented: $isEditingProfile) {
                editProfileSheet
            }
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
                    profileImageData = data
                }
            }
        }
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 22) {
                avatar(size: 92)

                HStack(spacing: 0) {
                    statistic(value: "0", title: "Gönderi")
                    Spacer(minLength: 8)
                    statistic(value: "0", title: "Takipçi")
                    Spacer(minLength: 8)
                    statistic(value: "0", title: "Takip")
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(displayName)
                    .font(.headline.weight(.semibold))
                Text("@\(username)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(bio)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 18)
    }

    private var profileActions: some View {
        HStack(spacing: 10) {
            Button {
                isEditingProfile = true
            } label: {
                Text("Profili düzenle")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            Button {} label: {
                Image(systemName: "person.badge.plus")
                    .font(.subheadline.weight(.semibold))
                    .frame(width: 44, height: 38)
                    .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Kişi ekle")
        }
        .padding(.horizontal, 18)
    }

    private var postSection: some View {
        VStack(spacing: 18) {
            HStack {
                Image(systemName: "square.grid.3x3")
                    .font(.subheadline.weight(.semibold))
                Text("Gönderiler")
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }
            .padding(.horizontal, 18)

            ContentUnavailableView(
                "Henüz gönderi yok",
                systemImage: "camera",
                description: Text("Paylaştığın fotoğraf ve videolar burada görünecek.")
            )
            .padding(.vertical, 28)
        }
    }

    private func statistic(value: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.semibold))
                .contentTransition(.numericText())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(minWidth: 54)
        .accessibilityElement(children: .combine)
    }

    private func avatar(size: CGFloat) -> some View {
        Group {
            if let data = profileImageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(Color(uiColor: .tertiarySystemFill))
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: size * 0.42))
                            .foregroundStyle(.secondary)
                    }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(uiColor: .separator).opacity(0.25), lineWidth: 1))
        .accessibilityLabel("Profil fotoğrafı")
    }

    private var editProfileSheet: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            avatar(size: 88)
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Text("Fotoğrafı değiştir")
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section("Hesap bilgileri") {
                    TextField("Ad", text: $displayName)
                        .textContentType(.name)
                    TextField("Kullanıcı adı", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: username) { _, value in
                            username = value.filter { $0.isLetter || $0.isNumber || $0 == "_" || $0 == "." }
                        }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Biyografi")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $bio)
                            .frame(minHeight: 90)
                    }
                }
            }
            .navigationTitle("Profili düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { isEditingProfile = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bitti") { isEditingProfile = false }
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
