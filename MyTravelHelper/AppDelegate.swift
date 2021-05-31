//
//  AppDelegate.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let notice = SearchTrainRouter.createModule()
        
        // Issue - 2: window was not set and it was returning false
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(rootViewController: notice)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
}

