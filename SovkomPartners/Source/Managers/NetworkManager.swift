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
        guard let url = URL(string: "https://backoffice.halvacard.ru/public-api/categories") else { return }
        
        dataTask(url: url) { data in
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
    
//    func categoriesDict(completion: @escaping (([Category]?) -> Void)) {
//        guard let url = URL(string: "https://backoffice.halvacard.ru/public-api/categories") else { return }
//
//        dataTask(url: url) { data in
//            if let data = data,
//                let array = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
//                let categories = array.compactMap { Category(dictionary: $0) }
//                completion(categories)
//            } else {
//                completion(nil)
//            }
//        }
//    }
    
    func promos(completion: @escaping (([Promo]?) -> Void)) {
        guard let url = URL(string: "https://backoffice.halvacard.ru/public-api/promos") else { return }
        
        dataTask(url: url) { data in
            if let data = data {
                do {
                    let promos = try self.decoder.decode([Promo].self, from: data)
                    completion(promos)
                    return
                } catch {
                    print(error)
                }
            }
            
            completion(nil)
        }
    }
    
    func banners(completion: @escaping (([Banner]?) -> Void)) {
        guard let url = URL(string: "https://backoffice.halvacard.ru/public-api/banners") else { return }
        
        dataTask(url: url) { data in
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
    
    private func dataTask(url: URL, completion: @escaping ((Data?) -> Void)) {
        let task = session.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
    }
}
