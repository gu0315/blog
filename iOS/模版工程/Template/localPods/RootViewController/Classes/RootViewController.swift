//
//  RootViewController.swift
//  RootViewController
//
//  Created by 顾钱想 on 2022/7/19.
//

import UIKit
// Swift 类中将需要暴露给 Objective-C 模块引用的类，用 public 申明
// Swift 类中需要暴露给 Objective-C 的方法要用关键字 @objc
// 在 Objective-C 类中引用 ProductName-Swift.h 头文件即可引用暴露给 Objective-C 的 Swift 的类和方法

public class RootViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
    }

    @objc public static func setRootViewController() {
        print("我正在初始化根控制器")
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        if (UIApplication.shared.delegate?.window != nil) {
            let apWindow: UIWindow? = UIApplication.shared.windows.first
            apWindow?.makeKeyAndVisible()
            apWindow?.rootViewController = RootViewController()
        }
    }
}
