//
//  AppDelegate.swift
//  Template
//
//  Created by 顾钱想 on 2022/7/9.
//

import UIKit

@main
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 自动注册
        // 判断是OC还是Swift OC:__C.IntegrationProtocol Swift:Template.AProtocol
        let arr = String(reflecting: IntegrationProtocol.self).description.split(separator: ".")
        if arr.first == "__C" {
            let aprotocol = NSProtocolFromString(String(arr[1]))
            IntegrationManager.executeArray(for: aprotocol!)
        } else {
            let aprotocol = NSProtocolFromString(String(reflecting: IntegrationProtocol.self))
            IntegrationManager.executeArray(for: aprotocol!)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

