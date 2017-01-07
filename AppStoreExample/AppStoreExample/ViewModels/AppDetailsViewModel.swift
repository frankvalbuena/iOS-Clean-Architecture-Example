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
    
    init(appID: String, locator: UseCaseLocatorProtocol) {
        guard let details = locator.getUseCase(ofType: GetAppDetails.self)?.getDetails(appstoreId: appID) else {
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
        
        if let bannerURL = details.bannerURL {
            imageDownloader.download(URLRequest(url: bannerURL)) { [weak self] response in
                if let image = response.result.value {
                    self?.banner = image
                    self?.onBannerLoaded?()
                }
            }
        }
    }
}
