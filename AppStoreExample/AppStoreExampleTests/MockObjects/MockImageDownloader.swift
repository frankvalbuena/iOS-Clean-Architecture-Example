//
//  MockImageDownloader.swift
//  AppStoreExample
//
//  Created by eli on 1/17/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit
@testable import AppStoreExample

struct MockImageDownloader {
    
    typealias Image = UIImage
    
    enum DownloaderResult {
        case sucess
        case failure(errorMessage: String)
    }
    
    let result: DownloaderResult
    
    init(result: DownloaderResult) {
        self.result = result
    }
    
}

extension MockImageDownloader: ImageDownloaderService {
    func image(withIdentifier identifier: String) -> Image? {
        return nil
    }
    
    func download(_ urlRequest: URLRequest, completionBlock: @escaping (UIImage?, Error?) -> Void) {
        switch result {
        case .sucess:
            completionBlock(UIImage(), nil)
            break
        case .failure(let errorMessage):
            completionBlock(nil, mockError(message: errorMessage))
            break
        }
    }
}

private extension MockImageDownloader {

    func mockError(message: String) -> Error {
        let errorDomain = "Appstore.Mockimagedownloader"
        let errorDict = [NSLocalizedDescriptionKey: message]
        return NSError(domain: errorDomain, code: 123, userInfo: errorDict)
    }
    
}
