//
//  SearchFacetsModel.swift
//  Segmentify

import Foundation

public class FacetedBaseResponseModel : NSObject, NSCopying {
    public var products:[ProductRecommendationModel]?
    public var facets=[Facet]()
    public var meta:FacetMetaModel?
    public var contents:FacetedCustomContent?
    public var banners:SearchBannerModel?
    public var meanings=[String]()
    
    public  override init() {
        
    }
    
    public init(products: [ProductRecommendationModel], facets:[Facet], meta:FacetMetaModel?, contents:FacetedCustomContent? ,banners:SearchBannerModel?, meanings:[String]) {
        self.products = products
        self.facets = facets
        self.meta = meta
        self.contents = contents
        self.banners = banners
        self.meanings = meanings
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        var mProducts = [ProductRecommendationModel]()
        for p in products! {
            mProducts.append(p.copy() as! ProductRecommendationModel)
        }
        
        let copy = FacetedBaseResponseModel(products: mProducts, facets: facets, meta:meta, contents:contents, banners:banners, meanings: meanings)
        return copy
    }
}
