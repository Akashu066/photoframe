//
//  AppDelegate.swift
//  photoframe
//
//  Created by Bhavi Tech on 23/11/21.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 1)
        IQKeyboardManager.shared.enable = true
        
        return true
    }



}

