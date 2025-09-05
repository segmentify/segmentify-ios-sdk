//
//  ContentView.swift
//  native-push-app
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

struct ContentView: View {
    @State private var fcmToken: String = "No Recieved Yet"
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
                        HStack {
                            Text("APNs Registration:")
                            Spacer()
                            Text(isRegisteredForRemote ? "Registered" : "Not Registered")
                                .foregroundColor(.secondary)
                        }
                        Button("Request permission and Register APNS") {
                            requestNotificationsAndRegister()
                        }
                    }

                    Section(header: Text("FCM Token")) {
                        ScrollView(.vertical) {
                            Text(fcmToken)
                                .font(.footnote)
                                .textSelection(.enabled)
                                .padding(.vertical, 4)
                        }
                        HStack {
                            Button("Refresh Token") {
                                refreshFcmToken()
                            }
                            Spacer()
                            Button("Copy") {
                                UIPasteboard.general.string = fcmToken
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
                .navigationTitle("FCM iOS Demo")
            }
            .onAppear {
                observeAuthorizationStatus()
                observeRemoteRegistration()
                observeFcmTokenUpdates()
                refreshFcmToken()
            }
        }

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

        private func observeAuthorizationStatus() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    self.authStatus = settings.authorizationStatus
                }
            }
        }

        private func observeRemoteRegistration() {
            // APNs kayıt sonucu AppDelegate’de loglanır; burada kabaca durum yansıtalım
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isRegisteredForRemote = UIApplication.shared.isRegisteredForRemoteNotifications
            }
        }

        private func observeFcmTokenUpdates() {
            NotificationCenter.default.addObserver(forName: .fcmTokenUpdated, object: nil, queue: .main) { note in
                if let token = note.object as? String {
                    self.fcmToken = token
                }
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
                    self.observeRemoteRegistration()
                }
            }
        }

        private func refreshFcmToken() {
            Messaging.messaging().token { token, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.fcmToken = "Token cannot be retrieved: \(error.localizedDescription)"
                    } else if let token = token {
                        self.fcmToken = token
                    } else {
                        self.fcmToken = "Token returned empty"
                    }
                }
            }
        }
    }
