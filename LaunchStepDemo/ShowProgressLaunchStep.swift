//
//  ShowProgressLaunchStep.swift
//  LaunchStepDemo
//
//  Created by Stephan Heilner on 7/11/18.
//  Copyright © 2018 Stephan Heilner. All rights reserved.
//

import Foundation
import LaunchStep

class ShowProgressLaunchStep: LaunchStep {

    func showProgress() -> Bool {
        return true
    }
    
    func shouldRun() -> Bool {
        return true
    }
    
    func execute(progress: @escaping (Float) -> Void, completion: @escaping () -> Void) {
        let iterations = 5
        for i in 0..<iterations {
            progress(Float(i) / Float(iterations))
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        completion()
    }
    
}
