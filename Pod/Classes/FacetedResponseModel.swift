//
//  FacetedResponseModel.swift
//  Segmentify


import Foundation

public class FacetedResponseModel: Codable {
    let facets: [FacetElement]
    let meta: Meta
    let contents: [JSONAny]
    let queryVerboseLog: QueryVerboseLog
    let banners: [Banners]
    let meanings: [JSONAny]
    let products: [Product]
    let executable: Bool

    init(facets: [FacetElement], meta: Meta, contents: [JSONAny], queryVerboseLog: QueryVerboseLog, banners: [Banners], meanings: [JSONAny], products: [Product], executable: Bool) {
        self.facets = facets
        self.meta = meta
        self.contents = contents
        self.queryVerboseLog = queryVerboseLog
        self.banners = banners
        self.meanings = meanings
        self.products = products
        self.executable = executable
    }
}

class FacetElement: Codable {
    let property: String
    let items: [Item]
    let filtered: [JSONAny]
    let viewMode: String

    init(property: String, items: [Item], filtered: [JSONAny], viewMode: String) {
        self.property = property
        self.items = items
        self.filtered = filtered
        self.viewMode = viewMode
    }
}

class Item: Codable {
    let value: String
    let count: Int

    init(value: String, count: Int) {
        self.value = value
        self.count = count
    }
}

class Meta: Codable {
    let total: Int
    let page: Page
    let params: MetaParams

    init(total: Int, page: Page, params: MetaParams) {
        self.total = total
        self.page = page
        self.params = params
    }
}

class Page: Codable {
    let current, rows: Int
    let prev, next: Bool

    init(current: Int, rows: Int, prev: Bool, next: Bool) {
        self.current = current
        self.rows = rows
        self.prev = prev
        self.next = next
    }
}

class MetaParams: Codable {
    let defaultOrder: String
    let currentRow: Int
    let currency: String
    let isCurrencyPlaceBefore: Bool

    init(defaultOrder: String, currentRow: Int, currency: String, isCurrencyPlaceBefore: Bool) {
        self.defaultOrder = defaultOrder
        self.currentRow = currentRow
        self.currency = currency
        self.isCurrencyPlaceBefore = isCurrencyPlaceBefore
    }
}

class Banners: Codable {
    let id: String
    let instanceId: String
    let status: SearchBannerStatus
    let searchType: SearchType
    let name: String
    let bannerUrl: String
    let targetUrl: String
    let position: SearchBannerPositionType
    let width: String
    let height: String
    
    init(id: String, instanceId: String, status: SearchBannerStatus, searchType: SearchType, name: String, bannerUrl: String, targetUrl: String, position: SearchBannerPositionType, width: String, height: String){
        self.id = id
        self.instanceId = instanceId
        self.status = status
        self.searchType = searchType
        self.name = name
        self.bannerUrl = bannerUrl
        self.targetUrl = targetUrl
        self.position = position
        self.width = width
        self.height = height
    }
}

enum SearchBannerStatus:String, Codable {
    case ACTIVE, PASSIVE, DRAFT, DELETED
}

enum SearchType:String, Codable {
    case INSTANT, FACETED
}

enum SearchBannerPositionType:String, Codable {
    case RESULTS_FOOTER, RESULTS_HEADER, FILTERS_FOOTER, FILTERS_HEADER, ASSETS_FOOTER, ASSETS_HEADER
}

class Product: Codable {
    let productId, name: String
    let url: String
    let image: String
    let price: Double
    let priceText: String
    let oldPrice: Double?
    let oldPriceText: String
    let specialPriceText: String
    let category: [String]
    let lastUpdateTime: Int
    let inStock: Bool
    let stockCount, insertTime, publishTime: Int
    let brand: String
    let labels: [String]?
    let params: [String:String]
    let language: String
    let currency: String
    let lastBoughtTime: Int

    init(productId: String, name: String, url: String, image: String, price: Double, priceText: String, oldPrice: Double?, oldPriceText: String, specialPriceText: String, category: [String], lastUpdateTime: Int, inStock: Bool, stockCount: Int, insertTime: Int, publishTime: Int, brand: String, labels: [String]?, params: [String:String], language: String, currency: String, lastBoughtTime: Int) {
        self.productId = productId
        self.name = name
        self.url = url
        self.image = image
        self.price = price
        self.priceText = priceText
        self.oldPrice = oldPrice
        self.oldPriceText = oldPriceText
        self.specialPriceText = specialPriceText
        self.category = category
        self.lastUpdateTime = lastUpdateTime
        self.inStock = inStock
        self.stockCount = stockCount
        self.insertTime = insertTime
        self.publishTime = publishTime
        self.brand = brand
        self.labels = labels
        self.params = params
        self.language = language
        self.currency = currency
        self.lastBoughtTime = lastBoughtTime
    }
}

class QueryVerboseLog: Codable {
    init() {
    }
}

typealias Facets = [FacetedResponseModel]

// Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
