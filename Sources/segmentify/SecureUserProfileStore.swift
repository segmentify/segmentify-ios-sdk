import CryptoKit
import Foundation
import Security

protocol KeychainStorage {
    func data(for key: String) -> Data?
    func set(_ data: Data?, for key: String)
    func delete(key: String)
}

final class SystemKeychainStorage: KeychainStorage {
    private let service: String

    init(service: String) {
        self.service = service
    }

    func data(for key: String) -> Data? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        return item as? Data
    }

    func set(_ data: Data?, for key: String) {
        delete(key: key)

        guard let data else {
            return
        }

        var query = baseQuery(for: key)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        SecItemAdd(query as CFDictionary, nil)
    }

    func delete(key: String) {
        let query = baseQuery(for: key)
        SecItemDelete(query as CFDictionary)
    }

    private func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
    }
}

final class SecureUserProfileStore {
    static let queue = DispatchQueue(label: "com.segmentify.sdk.userprofile.store")

    private static let encryptionKeyAccount = "encryption-key"
    private static let snapshotAccount = "profile-snapshot"

    private let storage: KeychainStorage
    private let service: String

    init(storage: KeychainStorage? = nil, service: String = "com.segmentify.sdk.userprofile") {
        self.service = service
        self.storage = storage ?? SystemKeychainStorage(service: service)
    }

    func shouldSendIdentify(_ params: [String: Any], completion: @escaping (Bool) -> Void) {
        Self.queue.async {
            let shouldSend = self.shouldSendIdentifySync(params)
            completion(shouldSend)
        }
    }

    func saveSnapshot(_ params: [String: Any], completion: (() -> Void)? = nil) {
        Self.queue.async {
            self.saveSnapshotSync(params)
            completion?()
        }
    }

    private func shouldSendIdentifySync(_ params: [String: Any]) -> Bool {
        guard let incoming = canonicalJSONData(from: params) else {
            return true
        }

        guard let stored = loadSnapshotPlaintextData() else {
            return true
        }

        return stored != incoming
    }

    private func saveSnapshotSync(_ params: [String: Any]) {
        guard let plaintext = canonicalJSONData(from: params),
              let encrypted = encrypt(plaintext) else {
            return
        }
        storage.set(encrypted, for: Self.snapshotAccount)
    }

    private func loadSnapshotPlaintextData() -> Data? {
        guard let encrypted = storage.data(for: Self.snapshotAccount),
              let plaintext = decrypt(encrypted) else {
            return nil
        }
        return plaintext
    }

    private func encryptionKey() -> SymmetricKey? {
        if let existing = storage.data(for: Self.encryptionKeyAccount) {
            return SymmetricKey(data: existing)
        }

        let key = SymmetricKey(size: .bits256)
        storage.set(key.withUnsafeBytes { Data($0) }, for: Self.encryptionKeyAccount)
        return key
    }

    private func encrypt(_ data: Data) -> Data? {
        guard let key = encryptionKey() else {
            return nil
        }

        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            return nil
        }
    }

    private func decrypt(_ data: Data) -> Data? {
        guard let key = encryptionKey() else {
            return nil
        }

        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            return nil
        }
    }
}

func canonicalJSONData(from value: Any) -> Data? {
    let normalized = normalizeForCanonicalJSON(value)

    guard JSONSerialization.isValidJSONObject(normalized) else {
        return nil
    }

    do {
        return try JSONSerialization.data(
            withJSONObject: normalized,
            options: [.sortedKeys, .withoutEscapingSlashes]
        )
    } catch {
        return nil
    }
}

private func normalizeForCanonicalJSON(_ value: Any) -> Any {
    if let dictionary = value as? [String: Any] {
        let sorted = dictionary.sorted { $0.key < $1.key }
        var normalized: [String: Any] = [:]
        for (key, nestedValue) in sorted {
            normalized[key] = normalizeForCanonicalJSON(nestedValue)
        }
        return normalized
    }

    if let dictionary = value as? [AnyHashable: Any] {
        let stringKeyed = dictionary.reduce(into: [String: Any]()) { result, entry in
            result[String(describing: entry.key)] = entry.value
        }
        return normalizeForCanonicalJSON(stringKeyed)
    }

    if let array = value as? [Any] {
        return array.map { normalizeForCanonicalJSON($0) }
    }

    return value
}
