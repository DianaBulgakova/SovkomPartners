//
//  RequestProvider.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 10.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation
import CoreLocation

private protocol RequestPathComponents {
    
    var baseURLPath: String? { get }
    var components: (method: String, path: String) { get }
}

extension RawRepresentable where RawValue == String {
    
    var components: (method: String, path: String) {
        let components = rawValue.components(separatedBy: ":")
        
        return (components[0], components[1])
    }
}

private enum StoresRequestPath: String, RequestPathComponents {
    
    var baseURLPath: String? { "https://backoffice.halvacard.ru/public-api" }
    
    case categories = "GET:categories"
    case promos = "GET:v2/promos"
    case promoInfo = "GET:v2/promoWithShops"
    case storesWithMall = "GET:shopsWithMall"
    case store = "GET:shop"
    case storeAddresses = "GET:shopAddresses"
    case malls = "GET:v2/malls"
    case storesForCategory = "GET:categoryWithShops"
    case search = "GET:v2/shop_and_mall"
    case banners = "GET:banners"
    case nearestStores = "GET:v2/nearestStoresClustered"
    case storesInCluster = "GET:nearestStoresInCluster"
    case favorites = "GET:favorites"
    case setFavorite = "POST:favorite"
    case removeFavorite = "DELETE:favorite"
}

enum RequestProvider {
    
    static func categories() -> URLRequest? {
        return self.request(path: .categories)
    }
    
    static func promos() -> URLRequest? {
        return self.request(path: .promos)
    }
    
    static func promoInfo(promoId: String, page: Int) -> URLRequest? {
        return self.request(path: .promoInfo,
                            query: [
                                "id": promoId,
                                "pageNumber": page,
                                "n": Constants.paginationLimit,
                            ])
    }
    
    static func storesForMall(mallId: String, page: Int) -> URLRequest? {
        return self.request(path: .storesWithMall,
                            query: [
                                "mallId": mallId,
                                "pageNumber": page,
                                "n": Constants.paginationLimit,
                            ])
    }
    
    static func officesForStore(storeId: String) -> URLRequest? {
        return self.request(path: .storeAddresses,
                            query: [
                                "shopId": storeId,
                            ])
    }
    
    static func malls(page: Int) -> URLRequest? {
        return self.request(path: .malls,
                            query: [
                                "pageNumber": page,
                                "n": Constants.paginationLimit,
                            ])
    }
    
    static func store(id: String) -> URLRequest? {
        return self.request(path: .store,
                            query: [
                                "shopId": id,
                            ])
    }
    
    static func stores(categoryId: String,
                       page: Int,
                       filters: [String: Any]?) -> URLRequest? {
        var query: [String: Any] = [
            "id": categoryId,
            "pageNumber": page,
            "n": Constants.paginationLimit,
        ]
        
        if let filters = filters {
            query = query.merging(with: filters)
        }
        
        return self.request(path: .storesForCategory,
                            query: query)
    }
    
    static func stores(forSearch term: String) -> URLRequest? {
        return self.request(path: .search,
                            query: [
                                "search": term,
                            ])
    }
    
    static func banners() -> URLRequest? {
        return self.request(path: .banners,
                            query: [
                                "time": Date().string(as: .oldISO8601),
                            ])
    }
    
    static func nearestStores(coordinates: CLLocationCoordinate2D,
                              radius: CLLocationDistance,
                              categoryId: String?,
                              storeId: String?) -> URLRequest? {
        return self.request(path: .nearestStores,
                            query: [
                                "lat": coordinates.latitude,
                                "lon": coordinates.longitude,
                                "radius": Int(radius),
                                "categoryId": categoryId,
                                "shopId": storeId,
                            ])
    }
    
    static func storesInCluster(clusterId: String,
                                categoryId: String?,
                                storeId: String?) -> URLRequest? {
        return self.request(path: .storesInCluster,
                            query: [
                                "clusterId": clusterId,
                                "categoryId": categoryId,
                                "shopId": storeId,
                            ])
    }
    
    static func favorites(categoryId: String?) -> URLRequest? {
        return self.request(path: .favorites,
                            query: [
                                "categoryId": categoryId,
                            ])
    }
    
    static func changeFavorites(partnerId: String, state: Bool) -> URLRequest? {
        return self.request(path: state ? .setFavorite : .removeFavorite,
                            urlPathComponent: [partnerId])
    }
}

// MARK: - Help Methods

extension RequestProvider {
    
    private static func request(path: StoresRequestPath,
                                urlPathComponent: [String] = [],
                                query: [String: Any?] = [:]) -> URLRequest? {
        //        var query = query
        //        if let region = HUBSettings.shared.currentCity?.kladrId {
        //            query["regionId"] = region
        //        }
        //
        //        var headers = [String: String?]()
        //        if HUBPartnerHelper.isFavoritesAvailable {
        //            headers["userId"] = HUBCDUser.findFirst()?.storesUserId
        //        }
        
        let urlRequest = self.buildRequest(path: path,
                                           urlPathComponents: urlPathComponent,
                                           query: query)
        
        return urlRequest
    }
    
    private static func buildRequest(path: RequestPathComponents,
                                     additionalUri: String? = nil,
                                     urlPathComponents: [Any] = [],
                                     query: [String: Any?] = [:],
                                     body: Any? = nil,
                                     headers: [String: String?] = [:]) -> URLRequest? {
        guard var baseURLPath = path.baseURLPath else { return nil }
        
        if let uri = additionalUri {
            baseURLPath.append(uri)
        }
        
        guard var url = URL(string: baseURLPath) else { return nil }
        
        let requestComponents = path.components
        
        if !requestComponents.path.isEmpty {
            url.appendPathComponent(requestComponents.path)
        }
        
        for component in urlPathComponents {
            url.appendPathComponent(String(describing: component))
        }
        
        for (name, item) in query {
            if let item = item,
                let value = String(describing: item).removingPercentEncoding,
                let valueParameter = value.urlEncoded {
                let symbol = url.query != nil ? "&" : "?"
                let newUrl = url.absoluteString + symbol + "\(name)=\(valueParameter)"
                url = URL(string: newUrl) ?? url
            }
        }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 20)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        urlRequest.httpMethod = requestComponents.method
        
        for (key, value) in headers {
            guard let value = value else { continue }
            
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}

private extension Dictionary {
    
    func merging(with dictionary: [Key: Value]) -> [Key: Value] {
        var result: [Key: Value] = self
        
        for (key, value) in dictionary {
            result[key] = value
        }
        
        return result
    }
}
