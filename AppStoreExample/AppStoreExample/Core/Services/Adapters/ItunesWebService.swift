//
//  ItunesWebService.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 1/3/17.
//  Copyright © 2017 Frank Valbuena. All rights reserved.
//

import Foundation
import Alamofire

final class ItunesWebService: AppStoreService {
    static let endPoint = "https://itunes.apple.com/us/rss/topfreeapplications/"
    
    func retrieveTopFreeApps(count: Int, completion: @escaping (AppStoreResponse) -> Void) {
        
        AF.request(type(of: self).endPoint + "limit=\(count)/json").responseJSON
        { response in
            guard let urlResponse = response.response else {
                if .notConnectedToInternet == (response.error?.underlyingError as? URLError)?.code {
                    completion(.notConnectedToInternet)
                } else {
                    completion(.failure)
                }
                return
            }
            
            switch urlResponse.statusCode {
            case 200...299:
                if case .success(let json) = response.result,
                    let jsonDictionary = json as? NSDictionary,
                    let apps = ItunesWebService.parse(response: jsonDictionary)
                {
                   completion(.success(apps: apps))
                } else {
                    completion(.failure)
                }
            case NSURLErrorNotConnectedToInternet:
                completion(.notConnectedToInternet)
            default:
                completion(.failure)
            }
        }
    }
}

// MARK: Parsing

private extension ItunesWebService {
    static func parse(response: NSDictionary) -> [AppData]? {
        guard let feed = response["feed"] as? NSDictionary,
            let entry = feed["entry"] as? [NSDictionary]
        else {
            return nil
        }
        return entry.enumerated().map(parseApp).filter { $0 != nil }.map { $0! }
    }
    
    static func parseApp(rank: Int, data: NSDictionary) -> AppData? {
        guard let appStoreId = data.value(forKeyPath: "id.attributes.im:id") as? String else {
            return nil
        }
        
        let images = (data.value(forKey: "im:image") as? [NSDictionary])?.map
        { (image: NSDictionary) -> (height: String?, url: URL?) in
            let label = image.value(forKey: "label") as? String
            return (height: image.value(forKeyPath: "attributes.height") as? String,
                    url: label != nil ? URL(string: label!) : nil)
        }.filter {
            $0.height != nil && $0.url != nil
        }.sorted {
            let lhs = Int($0.height!) ?? 0
            let rhs = Int($1.height!) ?? 0
            return lhs < rhs
        }
        
        return RawAppData(appstoreID: appStoreId,
                          shortName: (data.value(forKeyPath: "im:name.label") as? String) ?? "",
                          detailName: (data.value(forKeyPath: "title.label") as? String) ?? "",
                          artist: (data.value(forKeyPath: "im:artist.label") as? String) ?? "",
                          category: (data.value(forKeyPath: "category.attributes.term") as? String) ?? "",
                          releaseDate: (data.value(forKeyPath: "im:releaseDate.attributes.label") as? String) ?? "",
                          summary: (data.value(forKeyPath: "summary.label") as? String) ?? "",
                          rights: (data.value(forKeyPath: "rights.label") as? String) ?? "",
                          bannerURL: images?.last?.url,
                          iconURL: images?.first?.url,
                          rank: rank)
    }
}
