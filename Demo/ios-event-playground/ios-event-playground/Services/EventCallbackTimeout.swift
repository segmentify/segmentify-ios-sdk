import Foundation

enum EventCallbackTimeout {
    /// Matches SegmentifyConnectionManager's 10s request timeout plus a small buffer
    /// so the playground fallback appears only after the network call can finish.
    private static let defaultSeconds: TimeInterval = 12

    static func run<T>(
        seconds: TimeInterval = defaultSeconds,
        fallback: T,
        operation: (@escaping (T) -> Void) -> Void
    ) async -> T {
        await withCheckedContinuation { continuation in
            let lock = NSLock()
            var finished = false

            func finish(_ value: T) {
                lock.lock()
                defer { lock.unlock() }
                guard !finished else { return }
                finished = true
                continuation.resume(returning: value)
            }

            operation { finish($0) }

            DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + seconds) {
                finish(fallback)
            }
        }
    }

    static func runVoid(
        seconds: TimeInterval = defaultSeconds,
        operation: (@escaping () -> Void) -> Void
    ) async {
        _ = await run(seconds: seconds, fallback: ()) { complete in
            operation { complete(()) }
        }
    }
}
