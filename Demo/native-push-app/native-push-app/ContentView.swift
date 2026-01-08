//
//  ContentView.swift
//  native-push-app
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

struct ProductData: Identifiable, Hashable {
    let id: String
    let imageUrl: String
}

struct ContentView: View {
    @State private var path = NavigationPath()
    
    @State private var fcmToken: String = "No Recieved Yet"
    @State private var authStatus: UNAuthorizationStatus = .notDetermined
    @State private var isRegisteredForRemote: Bool = false
    @State private var lastLog: String = ""

    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section(header: Text("Notification Status")) {
                    HStack {
                        Text("Permission:")
                        Spacer()
                        Text(statusText(authStatus)).foregroundColor(.secondary)
                    }
                    HStack {
                        Text("APNs Reg:")
                        Spacer()
                        Text(isRegisteredForRemote ? "Yes" : "No").foregroundColor(.secondary)
                    }
                    Button("Request & Register") {
                        requestNotificationsAndRegister()
                    }
                }

                Section(header: Text("FCM Token")) {
                    ScrollView(.vertical) {
                        Text(fcmToken).font(.caption).textSelection(.enabled)
                    }
                    Button("Copy Token") {
                        UIPasteboard.general.string = fcmToken
                    }
                }

                Section(header: Text("Tests")) {
                    Button("Simulate Deep Link (Local Test)") {
                        let demoProduct = ProductData(id: "999", imageUrl: "https://via.placeholder.com/300")
                        path.append(demoProduct)
                    }
                    
                    if !lastLog.isEmpty {
                        Text("Log: \(lastLog)").font(.caption).foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Segmentify Demo")
            .navigationDestination(for: ProductData.self) { product in
                ProductDetailView(product: product)
            }
        }
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onAppear {
            checkPermissions()
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        // sample link: myapp://product?id=10&image=http...
        guard url.scheme == "myapp" else {
            lastLog = "Hata: Yanlış şema -> \(url.scheme ?? "yok")"
            return
        }
        
        if url.host == "product" {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let pId = components?.queryItems?.first(where: { $0.name == "id" })?.value
            let pImg = components?.queryItems?.first(where: { $0.name == "image" })?.value
            
            if let safeId = pId, let safeImg = pImg {
                let newProduct = ProductData(id: safeId, imageUrl: safeImg)
                path.append(newProduct)
                lastLog = "Gidiliyor -> ID: \(safeId)"
            }
        }
    }


    private func checkPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { self.authStatus = settings.authorizationStatus }
        }
        NotificationCenter.default.addObserver(forName: .fcmTokenUpdated, object: nil, queue: .main) { note in
            if let token = note.object as? String { self.fcmToken = token }
        }
        Messaging.messaging().token { token, _ in
            if let t = token { self.fcmToken = t }
        }
    }

    private func requestNotificationsAndRegister() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.checkPermissions()
                if granted { UIApplication.shared.registerForRemoteNotifications() }
            }
        }
    }
    
    private func statusText(_ status: UNAuthorizationStatus) -> String {
        switch status {
        case .authorized: return "Authorized"
        case .denied: return "Denied"
        case .notDetermined: return "Not Determined"
        default: return "Unknown"
        }
    }
}

struct ProductDetailView: View {
    let product: ProductData
    var body: some View {
        VStack {
            Text("Product ID: \(product.id)").font(.headline)
            
            AsyncImage(url: URL(string: product.imageUrl)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Image(systemName: "photo.fill").foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(height: 250)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Details")
    }
}

extension Notification.Name {
    static let fcmTokenUpdated = Notification.Name("fcmTokenUpdated")
}
