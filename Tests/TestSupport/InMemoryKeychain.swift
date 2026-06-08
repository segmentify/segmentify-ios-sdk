import Foundation
@testable import Segmentify

final class InMemoryKeychain: KeychainStorage {
    private var storage: [String: Data] = [:]
    private let lock = NSLock()

    func data(for key: String) -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return storage[key]
    }

    func set(_ data: Data?, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        if let data {
            storage[key] = data
        } else {
            storage.removeValue(forKey: key)
        }
    }

    func delete(key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage.removeValue(forKey: key)
    }

    func reset() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAll()
    }
}
