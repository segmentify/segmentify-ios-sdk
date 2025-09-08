//
//  ContentView.swift
//  native-push-app
//

import SwiftUI
import UserNotifications

extension Notification.Name {
    static let apnsTokenUpdated = Notification.Name("apnsTokenUpdated")
    static let apnsRegistrationStateChanged = Notification.Name("apnsRegistrationStateChanged")
}

struct ContentView: View {
    @State private var apnsToken: String = "No Received Yet"
    @State private var authStatus: UNAuthorizationStatus = .notDetermined
    @State private var isRegisteredForRemote: Bool = false
    @State private var lastLog: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notification and Registration Status")) {
                    HStack {
                        Text("Notification Permission:")
                        Spacer()
                        Text(statusText(authStatus))
                            .foregroundColor(.secondary)
                    }
                    Button("Request permission and Register APNS") {
                        requestNotificationsAndRegister()
                    }
                }

                Section(header: Text("APNs Token")) {
                    ScrollView(.vertical) {
                        Text(apnsToken)
                            .font(.footnote)
                            .textSelection(.enabled)
                            .padding(.vertical, 4)
                    }
                    HStack {
                        Button("Refresh Token") {
                            refreshApnsTokenFromStorage()
                        }
                        Spacer()
                        Button("Copy") {
                            UIPasteboard.general.string = apnsToken
                        }
                    }
                }

                Section(header: Text("Test Assistants")) {
                    Button("Open Notification Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Write Foreground Test Log") {
                        lastLog = "Date: \(Date())"
                        print("Test log: \(lastLog)")
                    }
                }

                if !lastLog.isEmpty {
                    Section(header: Text("Log")) {
                        Text(lastLog).font(.footnote)
                    }
                }
            }
            .navigationTitle("APNs iOS Demo")
        }
        .onAppear {
            attachObservers()
            observeAuthorizationStatus()
            observeRemoteRegistration()
            refreshApnsTokenFromStorage()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }

    // MARK: - Helpers

    private func statusText(_ status: UNAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Determined"
        case .denied:        return "Denied"
        case .authorized:    return "Authorized"
        case .provisional:   return "Provisional"
        case .ephemeral:     return "Ephemeral"
        @unknown default:    return "N/A"
        }
    }

    private func attachObservers() {
        NotificationCenter.default.addObserver(forName: .apnsTokenUpdated, object: nil, queue: .main) { note in
            if let token = note.object as? String {
                self.apnsToken = token
                self.lastLog = "APNs token updated."
            } else {
                self.refreshApnsTokenFromStorage()
            }
        }
        NotificationCenter.default.addObserver(forName: .apnsRegistrationStateChanged, object: nil, queue: .main) { _ in
            self.isRegisteredForRemote = UIApplication.shared.isRegisteredForRemoteNotifications
        }
    }

    private func observeAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authStatus = settings.authorizationStatus
            }
        }
    }

    private func observeRemoteRegistration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isRegisteredForRemote = UIApplication.shared.isRegisteredForRemoteNotifications
        }
    }

    private func requestNotificationsAndRegister() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.lastLog = "Permission Error: \(error.localizedDescription)"
                } else {
                    self.lastLog = "Permission granted? \(granted)"
                }
                self.observeAuthorizationStatus()
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func refreshApnsTokenFromStorage() {
        let token = UserDefaults.standard.string(forKey: "apnsToken") ?? "No Received Yet"
        self.apnsToken = token
    }
}
