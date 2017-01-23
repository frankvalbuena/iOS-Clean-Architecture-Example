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
    func image(withIdentifier identifier: String) -> Image?
    func download(_ urlRequest: URLRequest, completionBlock: @escaping (UIImage?, Error?) -> Void)
}

struct AlamoFireImageDownloader {
    
    fileprivate var downloader: ImageDownloader!
    
    private init() { }
    
    static func defaultDownloader() -> AlamoFireImageDownloader {
        var defaultInstance = AlamoFireImageDownloader()
        defaultInstance.downloader = ImageDownloader()
        return defaultInstance
    }
    
    static func defaultDownloaderWithCache() -> AlamoFireImageDownloader {
        var defaultInstance = AlamoFireImageDownloader()
        let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                              downloadPrioritization: .fifo,
                                              maximumActiveDownloads: 10,
                                              imageCache: AutoPurgingImageCache())
        defaultInstance.downloader = imageDownloader
        return defaultInstance
    }
    
}

extension AlamoFireImageDownloader: ImageDownloaderService {

    func image(withIdentifier identifier: String) -> Image? {
        return downloader.imageCache?.image(withIdentifier: identifier)
    }
    
    func download(_ urlRequest: URLRequest, completionBlock: @escaping (UIImage?, Error?) -> Void) {
        downloader.download(urlRequest) {
            response in
            completionBlock(response.result.value, response.result.error)
        }
    }
    
}
