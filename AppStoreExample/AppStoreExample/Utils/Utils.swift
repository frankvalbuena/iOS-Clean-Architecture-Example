//
//  Utils.swift
//  AppStoreExample
//
//  Created by Eli Pacheco on 1/12/17.
//  Copyright © 2017 Francisco Valbuena. All rights reserved.
//

import Foundation

struct Utils {
    static func createError(_ errorMessage: String, code: Int = -1234, domain: String = "com.example.cleanArch") -> NSError {
        return NSError(domain: domain,
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey : errorMessage])
    }
}
