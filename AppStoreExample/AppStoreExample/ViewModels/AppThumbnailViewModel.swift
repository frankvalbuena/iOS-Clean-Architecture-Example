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
    fileprivate let imageDownloader: ImageDownloaderService
    fileprivate var iconURL: URL? = nil
    fileprivate(set) lazy var placeholderIcon: UIImage? = self.buildPlaceholderImage()
    
    var appID: String
    var name: String
    var icon: UIImage? = nil
    var onDidLoad: (() -> Void)? = nil
    
    init(thumbnail: AppThumbnailDTO, imageDownloaderService: ImageDownloaderService) {
        name = thumbnail.name
        iconURL = thumbnail.iconURL
        appID = thumbnail.appstoreID
        imageDownloader = imageDownloaderService
    }
    
    func loadData() {
        guard let iconURL = self.iconURL else {
            icon = placeholderIcon
            return
        }
        
        icon = imageDownloader.image(withIdentifier: iconURL.absoluteString) ?? placeholderIcon
        // Thubnails are short lived object so it's ok to not use weak self in this case,
        // To make sure we don't miss callbacks.
        imageDownloader.download(URLRequest(url: iconURL)) {
            [weak self] imageDownloaded, error in
            
            if let image = imageDownloaded {
                self?.icon = image
            }
            self?.onDidLoad?()
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
        return lhs.appID == rhs.appID
    }
}
