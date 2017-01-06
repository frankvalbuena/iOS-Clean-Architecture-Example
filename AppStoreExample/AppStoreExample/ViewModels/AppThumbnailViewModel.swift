//
//  AppThumbnailViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

final class AppThumbnailViewModel {
    fileprivate static let imageSize = CGSize(width: 50, height: 50)
    fileprivate static let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                                         downloadPrioritization: .fifo,
                                                         maximumActiveDownloads: 10,
                                                         imageCache: AutoPurgingImageCache())
    fileprivate var iconURL: URL? = nil
    fileprivate var id: String
    fileprivate lazy var placeholderIcon: UIImage? = self.buildPlaceholderImage()
    
    var name: String
    var icon: UIImage? = nil
    var onDidLoad: (() -> Void)? = nil
    
    init(thumbnail: AppThumbnailDTO) {
        name = thumbnail.name
        iconURL = thumbnail.iconURL
        id = thumbnail.appstoreID
    }
    
    func loadData() {
        guard let iconURL = self.iconURL else {
            icon = placeholderIcon
            return
        }
        let downloader = AppThumbnailViewModel.imageDownloader
        
        icon = downloader.imageCache?.image(withIdentifier: iconURL.absoluteString) ?? placeholderIcon
        // Thubnails are short lived object so it's ok to not use weak self in this case,
        // To make sure we don't miss callbacks.
        AppThumbnailViewModel.imageDownloader.download(URLRequest(url: iconURL)) { response in
            if let image = response.result.value {
                self.icon = image
                self.onDidLoad?()
            }
        }
    }
}

private extension AppThumbnailViewModel {
    func buildPlaceholderImage() -> UIImage? {
        let size = AppThumbnailViewModel.imageSize
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.lightGray.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let placeholder = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return placeholder
    }
}

extension AppThumbnailViewModel: Equatable {
    public static func ==(lhs: AppThumbnailViewModel, rhs: AppThumbnailViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
