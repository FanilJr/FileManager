//
//  SceneDelegate.swift
//  FileManager
//
//  Created by Fanil_Jr on 19.10.2022.
//

import UIKit
import Locksmith

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let tabBarController = UITabBarController()

//    var isOnline: Bool?
    let userDefaults = UserDefaults.standard
//    var keyChain = KeychainSwift()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
//        keyChain.set(true, forKey: "isLogin")
//        keyChain.set("qwerty", forKey: "password")
        
//        userDefaults.set(true, forKey: "isLogin")
//        if userDefaults.bool(forKey: "isLogin") {
//            print("Open App")
//        } else {
//            print("Open LoginVC")
//        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let loginViewController = LoginViewController()
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        loginNavigationController.tabBarItem.title = "FileManager"
        loginNavigationController.tabBarItem.image = UIImage(systemName: "folder")
        
        let settingsViewController = SettingsViewController()
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationController.tabBarItem.title = "Settings"
        settingsNavigationController.tabBarItem.image = UIImage(systemName: "folder.badge.gearshape")
        
        tabBarController.viewControllers = [loginNavigationController, settingsNavigationController]
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

