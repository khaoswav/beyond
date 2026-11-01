import SwiftUI
import PhotosUI
import UIKit

struct CreatePostView: View {
    @EnvironmentObject private var store: BeyondStore
    @Environment(\.dismiss) private var dismiss
    @AppStorage("beyond.profile.displayName") private var displayName = "Khaos"
    @AppStorage("beyond.profile.username") private var username = "khaos"
    @State private var caption = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isPublishing = false

    private var canPublish: Bool {
        !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || imageData != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(displayName).font(.subheadline.weight(.semibold))
                            Text("@\(username)").font(.caption).foregroundStyle(.secondary)
                        }
                    }

                    TextField("Aklından geçenleri paylaş...", text: $caption, axis: .vertical)
                        .font(.title3)
                        .lineLimit(5...12)
                        .accessibilityLabel("Gönderi metni")

                    if let imageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    self.imageData = nil
                                    selectedPhoto = nil
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.white)
                                        .padding(9)
                                        .background(.black.opacity(0.65), in: Circle())
                                }
                                .padding(10)
                                .accessibilityLabel("Fotoğrafı kaldır")
                            }
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Fotoğraf ekle", systemImage: "photo")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                    }
                    .onChange(of: selectedPhoto) { _, item in
                        Task {
                            guard let data = try? await item?.loadTransferable(type: Data.self),
                                  let image = UIImage(data: data) else { return }
                            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1200, height: 1200))
                            let scale = min(1200 / image.size.width, 1200 / image.size.height)
                            let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
                            let rect = CGRect(x: (1200 - size.width) / 2, y: (1200 - size.height) / 2, width: size.width, height: size.height)
                            let thumbnail = renderer.image { _ in image.draw(in: rect) }
                            imageData = thumbnail.jpegData(compressionQuality: 0.72)
                        }
                    }

                    Text("Gönderilerin bu cihazda saklanır. Çevrimiçi paylaşım için sunucu bağlantısı henüz eklenmedi.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .navigationTitle("Yeni gönderi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Paylaş") {
                        guard !isPublishing else { return }
                        isPublishing = true
                        store.addPost(caption: caption, imageData: imageData)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canPublish || isPublishing)
                }
            }
        }
    }
}
