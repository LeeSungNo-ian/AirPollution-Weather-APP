//
//  SceneDelegate.swift
//  AirPollution-Weather-APP
//
//  Created by 이성노 on 2022/10/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .clear
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

}

