//
//  ImageDownloader.swift
//  AppStoreExample
//
//  Created by eli on 1/17/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

protocol ImageDownloaderService {
    func download(_ urlRequest: URLRequest, completionBlock: @escaping (UIImage?, Error?) -> Void)
}

struct AlamoFireImageDownloader: ImageDownloaderService {
    
    private var downloader: ImageDownloader!
    
    private init() { }
    
    static func defaultDownloader() -> AlamoFireImageDownloader {
        var defaultInstance = AlamoFireImageDownloader()
        defaultInstance.downloader = ImageDownloader()
        return defaultInstance
    }
    
    func download(_ urlRequest: URLRequest, completionBlock: @escaping (UIImage?, Error?) -> Void) {
        downloader.download(urlRequest) {
         response in
            completionBlock(response.result.value, response.result.error)
        }
    }
}
