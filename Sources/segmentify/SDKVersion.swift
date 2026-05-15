//
//  SDKVersion.swift
//  Segmentify

import Foundation

enum SDKVersion {
    static let value: String = {
        let bundle = resourceBundle
        guard let url = bundle.url(forResource: "version", withExtension: nil),
              let raw = try? String(contentsOf: url, encoding: .utf8) else {
            return "unknown"
        }
        let version = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return version.isEmpty ? "unknown" : version
    }()

    private static var resourceBundle: Bundle {
        #if SWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE
        return Bundle.module
        #else
        let resourceBundleName = "Segmentify_Segmentify"
        let candidates = [
            Bundle.main,
            Bundle(for: BundleToken.self)
        ]
        for bundle in candidates {
            if let url = bundle.url(forResource: resourceBundleName, withExtension: "bundle"),
               let resourceBundle = Bundle(url: url) {
                return resourceBundle
            }
        }
        return Bundle(for: BundleToken.self)
        #endif
    }
}

private final class BundleToken: NSObject {}
