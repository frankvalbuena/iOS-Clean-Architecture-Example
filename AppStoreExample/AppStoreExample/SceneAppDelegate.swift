//
//  SceneAppDelegate.swift
//  AppStoreExample
//
//  Created by Frank Valbuena on 4/05/20.
//  Copyright © 2020 Frank Valbuena. All rights reserved.
//

import Foundation
import UIKit
import Boundaries

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appBoundary = AppBoundary.Resolved()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appBoundary.rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
