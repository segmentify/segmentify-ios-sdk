import Foundation
import Segmentify

/// Segmentify + Firebase push settings from `Demo/native-push-app`.
enum SegmentifyPushConfiguration {
    static let apiKey = "5c571072-068e-40c5-8dbc-d8448158de19"
    static let dataCenterUrl = "https://gandalf-qa.segmentify.com"
    static let pushDataCenterUrl = "https://gimli-qa.segmentify.com"
    static let subDomain = "demo.segmentify.com"

    static func apply() {
        SegmentifyManager.config(
            appkey: apiKey,
            dataCenterUrl: dataCenterUrl,
            subDomain: subDomain
        )
        SegmentifyManager.setPushConfig(dataCenterUrlPush: pushDataCenterUrl)
    }
}
