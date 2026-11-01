import SwiftUI

struct SettingsView: View {
    @AppStorage("beyond.settings.appearance") private var appearance = "system"
    @AppStorage("beyond.settings.privateAccount") private var isPrivateAccount = false
    @AppStorage("beyond.settings.activityStatus") private var showsActivityStatus = true
    @AppStorage("beyond.settings.likeNotifications") private var likeNotifications = true
    @AppStorage("beyond.settings.followNotifications") private var followNotifications = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Görünüm") {
                    Picker("Uygulama görünümü", selection: $appearance) {
                        Text("Sistem").tag("system")
                        Text("Açık").tag("light")
                        Text("Koyu").tag("dark")
                    }
                    .pickerStyle(.segmented)
                }

                Section("Gizlilik") {
                    Toggle("Gizli hesap", isOn: $isPrivateAccount)
                    Toggle("Hareket durumunu göster", isOn: $showsActivityStatus)
                }

                Section("Bildirimler") {
                    Toggle("Beğeni bildirimleri", isOn: $likeNotifications)
                    Toggle("Takip bildirimleri", isOn: $followNotifications)
                }

                Section {
                    Label("Apple tasarım ilkeleriyle hazırlandı", systemImage: "apple.logo")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("Bu tercihler şu anda bu cihazda saklanır. Gizli hesap ve bildirim tercihleri sunucuya bağlı değildir.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
