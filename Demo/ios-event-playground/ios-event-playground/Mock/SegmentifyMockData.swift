import Foundation

enum SegmentifyMockData {
    static let userTraits: [String: Any] = [
        "email": "product@segmentify.com",
        "gender": "male",
        "age": 30,
        "location": "New York",
        "fullName": "",
        "loyalty_level": "gold",
        "emailConsent": "SUBSCRIBED",
        "whatsappConsent": "UNSUBSCRIBED",
        "smsConsent": "NOT_SET",
        "callConsent": "NOT_SET",
    ]

    enum CDP {
        static let identify: [String: Any] = [
            "email": "product@segmentify.com",
            "username": "product-user",
            "phone": "1234567890",
            "gender": "male",
            "source": "email-collection",
            "fullName": "Jane Doe",
            "callConsent": "SUBSCRIBED",
            "emailConsent": "UNSUBSCRIBED",
            "whatsappConsent": "NOT_SET",
            "smsConsent": "SUBSCRIBED",
        ]

        static let register: [String: Any] = [
            "email": "product@segmentify.com",
            "username": "product-user",
            "emailConsent": "SUBSCRIBED",
            "smsConsent": "NOT_SET",
        ]

        static let login: [String: Any] = [
            "email": "product@segmentify.com",
            "username": "product-user",
        ]

        static let logout: [String: Any] = [
            "email": "product@segmentify.com",
        ]

        static let phoneNumber = "1234567890"
        static let subscribeEmailAddress = "product@segmentify.com"
        static let subscribeEmailPurpose = "marketing"

        static let subscribeEmail: [String: Any] = [
            "channel": "email",
            "email": "product@segmentify.com",
            "purpose": "marketing",
        ]

        static let subscribeWhatsApp: [String: Any] = [
            "channel": "whatsapp",
            "phoneNumber": phoneNumber,
        ]

        static let subscribeSMS: [String: Any] = [
            "channel": "sms",
            "phoneNumber": phoneNumber,
        ]

        static let subscribeCall: [String: Any] = [
            "channel": "call",
            "phoneNumber": phoneNumber,
        ]

        static let unsubscribeEmail: [String: Any] = [
            "channel": "email",
            "email": "product@segmentify.com",
        ]

        static let unsubscribeWhatsApp: [String: Any] = [
            "channel": "whatsapp",
            "phoneNumber": phoneNumber,
        ]

        static let unsubscribeSMS: [String: Any] = [
            "channel": "sms",
            "phoneNumber": phoneNumber,
        ]

        static let unsubscribeCall: [String: Any] = [
            "channel": "call",
            "phoneNumber": phoneNumber,
        ]

        static let unsubscribeIosPush: [String: Any] = [
            "channel": "app_push",
        ]
    }

    enum Product {
        static let productId = "0986384"
        static let title = "Portable Document Scanner"
        static let price: NSNumber = 135.0
        static let oldPrice: NSNumber = 159.9
        static let image = "https://picsum.photos/200"
        static let category =
            "Electronics > Print, Copy, Scan & Fax > Scanners > Portable Scanners"
        static let brand = "Segmentify Store"
        static let inStock = true
        static let url = "https://example.com/product/SKU-1001"
        static let params: [String: AnyObject] = [
            "campaign": "black-friday" as AnyObject,
        ]
    }

    enum PageView {
        static let category = "Home Page"
        static let subCategory = "Home"
        static let params: [String: AnyObject] = [
            "campaign": "black-friday" as AnyObject,
        ]
    }

    enum Basket {
        static let viewTotalPrice: NSNumber = 129.9
        static let addPrice: NSNumber = 135.0
        static let removePrice: NSNumber = 129.9
        static let quantity: NSNumber = 1
        static let productList: [[String: Any]] = [
            ["productId": Product.productId, "quantity": 1, "price": 135.0],
        ]
    }

    enum Checkout {
        static let totalPrice: NSNumber = 135.0
        static let orderNo = "1234567890"
        static let productList: [[String: Any]] = [
            ["productId": Product.productId, "quantity": 1, "price": 135.0],
        ]
    }

    enum User {
        static let email = "product@segmentify.com"
        static let externalId = "product-user"
    }

    enum Interaction {
        static let widgetClick = (instanceId: "0986384", interactionId: "scn_e418dcd1aa000")
        static let widgetView = (instanceId: "0986384", interactionId: "scn_e418dcd1aa000")
        static let emailClick = (instanceId: "eml_e3dcb5d02e000", interactionId: "eml_e3dcb5d02e000")
        static let smsClick = (instanceId: "sms_1dce21709da60000", interactionId: "static")
        static let emailHashParams: [String: AnyObject] = [
            "step": "identify" as AnyObject,
            "channel": "email" as AnyObject,
            "type": "sgm-hash" as AnyObject,
            "identity": "utm_code" as AnyObject,
        ]
        static let pushViewInstanceId = ""
        static let pushClickInstanceId = ""
    }

    enum Search {
        static let beforeKeywordInstanceId = "BEFORE_SEARCH"
        static let beforeClickInstanceId = "bs_product"
        static let beforeClickInteractionId = "0986384"
        static let afterQuery = "kitchen"
        static let afterInstanceId = "SEARCH"
        static let afterClickInstanceId = "product"
        static let afterClickInteractionId = "0986384"
    }
}
