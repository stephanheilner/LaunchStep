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

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var launchSteps = [LaunchStep]()
        for _ in 0..<10 {
            launchSteps.append(ShowProgressLaunchStep())
        }

        let viewController = ViewController(nibName: nil, bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController(rootViewController: viewController)

        let launchProgressViewController = LaunchProgressViewController(launchScreenStoryboard: UIStoryboard(name: "LaunchScreen", bundle: Bundle.main), title: "Launching Demo", launchSteps: launchSteps)
        window?.rootViewController = launchProgressViewController
        window?.makeKeyAndVisible()
        
        launchProgressViewController.startLaunchSteps(simultaneous: true) {
            navigationController.willMove(toParent: launchProgressViewController)
            launchProgressViewController.addChild(navigationController)
            launchProgressViewController.view.addSubview(navigationController.view)
            navigationController.didMove(toParent: launchProgressViewController)
        }
        
        return true
    }

}

