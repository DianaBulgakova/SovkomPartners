//
//  SceneDelegate.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 03.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = UINavigationController(rootViewController: MainController())
        window?.makeKeyAndVisible()
    }
}
