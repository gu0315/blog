//
//  AppDelegate.swift
//  Template
//
//  Created by 顾钱想 on 2022/7/9.
//

import UIKit


@main
public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 自动注OC:__C.IntegrationProtocol Swift:Template.AProtocol
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

}

