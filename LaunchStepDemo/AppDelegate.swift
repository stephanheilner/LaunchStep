//
//  AppDelegate.swift
//  LaunchStepDemo
//
//  Created by Stephan Heilner on 7/11/18.
//  Copyright © 2018 Stephan Heilner. All rights reserved.
//

import UIKit
import LaunchStep

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var launchSteps = [LaunchStep]()
        for _ in 0..<10 {
            launchSteps.append(ShowProgressLaunchStep())
        }

        let viewController = ViewController(nibName: nil, bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let launchProgressViewController = LaunchProgressViewController(launchScreenStoryboard: UIStoryboard(name: "LaunchScreen", bundle: Bundle.main), title: "Launching Demo")
        launchProgressViewController.launchSteps = launchSteps
        window?.rootViewController = launchProgressViewController
        launchProgressViewController.startLaunchSteps(simultaneous: true) { [weak self] in
            self?.window?.rootViewController = UINavigationController(rootViewController: viewController)
            launchProgressViewController.dismiss(animated: true, completion: nil)
        }
        window?.makeKeyAndVisible()
        
        return true
    }

}

