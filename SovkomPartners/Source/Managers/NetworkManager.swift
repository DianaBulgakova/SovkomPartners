//
//  NetworkManager.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 03.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    private lazy var decoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    func categories(completion: @escaping (([Category]?) -> Void)) {
        let request = RequestProvider.categories()
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let categories = try self.decoder.decode([Category].self, from: data)
                    completion(categories)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func promos(completion: @escaping (([Promo]?) -> Void)) {
        let request = RequestProvider.promos()
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let promo = try self.decoder.decode(PromoRequest.self, from: data)
                    completion(promo.promos)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func banners(completion: @escaping (([Banner]?) -> Void)) {
        let request = RequestProvider.banners()
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let banner = try self.decoder.decode(BannerRequest.self, from: data)
                    completion(banner.banners)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func shops(categoryId: String, page: Int, completion: @escaping (([Shop]?) -> Void)) {
        let request = RequestProvider.stores(categoryId: categoryId, page: page, filters: nil)
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let shop = try self.decoder.decode(ShopRequest.self, from: data)
                    completion(shop.shops)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func shop(id: String, completion: @escaping ((Shop?) -> Void)) {
        let request = RequestProvider.store(id: id)
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let shop = try self.decoder.decode(Shop.self, from: data)
                    completion(shop)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func malls(page: Int, completion: @escaping (([Mall]?) -> Void)) {
        let request = RequestProvider.malls(page: page)
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let mall = try self.decoder.decode(MallRequest.self, from: data)
                    completion(mall.malls)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func promoInfo(promoId: String, page: Int, completion: @escaping ((PromoInfoRequest?) -> Void)) {
        let request = RequestProvider.promoInfo(promoId: promoId, page: page)
        
        dataTask(urlRequest: request) { data in
            if let data = data {
                do {
                    let promo = try self.decoder.decode(PromoInfoRequest.self, from: data)
                    completion(promo)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    private func dataTask(urlRequest: URLRequest?, completion: @escaping ((Data?) -> Void)) {
        guard let urlRequest = urlRequest else { return }
        
        let task = session.dataTask(with: urlRequest) { data, _, _ in
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
    }
}
