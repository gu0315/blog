//
//  AppDelegate.swift
//  Template
//
//  Created by 顾钱想 on 2022/7/9.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var application: UIApplication?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.application = application
        // 自动注OC:__C.IntegrationProtocol Swift:Template.AProtocol
        // 措施化无参SDK, TODO: 推送还是要自己配的
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

