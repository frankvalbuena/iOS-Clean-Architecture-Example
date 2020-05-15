//
//  AppDetailsViewModel.swift
//  AppStoreExample
//
//  Created by Francisco Valbuena on 1/4/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

final class AppDetailsViewModel {
    let name: String
    var banner: UIImage? = nil
    var onBannerLoaded: (() -> ())? = nil
    var summary: String
    let additionalInformation: [(type: String, value: String)]
    
    private let imageDownloader = ImageDownloader()
    
    init(appID: String, getAppDetails: GetAppDetails) {
        guard let details = getAppDetails(appstoreId: appID) else {
            self.name = ""
            self.summary = ""
            self.additionalInformation = []
            return
        }
        
        self.name = details.name
        self.summary = details.summary
        self.additionalInformation = [(type: "Artist:", value: details.artist),
                                      (type: "Category:", value: details.category),
                                      (type: "Release Date:", value: details.releaseDate),
                                      (type: "Rights:", value: details.rights)]
        
        guard let bannerURL = details.bannerURL else {
            return
        }
        self.imageDownloader.download(URLRequest(url: bannerURL)) { [weak self] response in
            if case .success(let image) = response.result {
                self?.banner = image
                self?.onBannerLoaded?()
            }
        }
    }
}
