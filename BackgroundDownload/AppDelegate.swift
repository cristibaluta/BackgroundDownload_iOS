//
//  AppDelegate.swift
//  BackgroundDownload
//
//  Created by Cristian Baluta on 15/03/2019.
//  Copyright © 2019 Imagin soft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> Void)?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("terminating app")
    }


}

