//
//  ViewController.swift
//  Fitness
//
//  Created by Josep Bordes Jové on 6/11/16.
//  Copyright © 2016 Josep Bordes Jové. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var viewController: ViewController = ViewController()
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.lightContent
    }
    
    return true
  }
}
