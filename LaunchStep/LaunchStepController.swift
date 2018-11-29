//
//  LaunchStepController.swift
//  LaunchStep
//
//  Created by Stephan Heilner on 7/10/18.
//

import Foundation

class LaunchStepController {
    
    var remainingLaunchSteps = [LaunchStep]()
    var currentLaunchStep: LaunchStep?
    var numberOfLaunchSteps: Float = 0
    var totalProgress: Float = 0
    
    fileprivate var progress: ((Float) -> Void)?
    fileprivate var completion: (() -> Void)?
    
    fileprivate let dispatchGroup = DispatchGroup()
    fileprivate let dispatchQueue = DispatchQueue(label: "com.hf.LaunchStep.LaunchStepController.DispatchQueue", qos: .userInitiated)
    
    func launch(launchSteps: [LaunchStep], simultaneous: Bool, progress: ((Float) -> Void)? = nil, completion: (() -> Void)? = nil) {
        self.remainingLaunchSteps = launchSteps
        self.numberOfLaunchSteps = Float(launchSteps.count)
        self.progress = progress
        self.completion = completion
        
        if !simultaneous, !launchSteps.isEmpty {
            performNextLaunchStep()
        } else {
            DispatchQueue.concurrentPerform(iterations: launchSteps.count) { index in
                execute(launchStep: launchSteps[index])
            }
        }
        dispatchGroup.notify(queue: dispatchQueue) { [weak self] in
            self?.completion?()
        }
    }
    
    func performNextLaunchStep() {
        dispatchGroup.enter()
        
        dispatchQueue.async {
            guard !self.remainingLaunchSteps.isEmpty else {
                // Finished Launch Steps
                self.dispatchGroup.leave()
                return
            }
            
            let launchStep = self.remainingLaunchSteps.remove(at: 0)
            self.execute(launchStep: launchStep) { [weak self] in
                guard let self = self else { return }
                
                if !self.remainingLaunchSteps.isEmpty {
                    self.performNextLaunchStep()
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    func execute(launchStep: LaunchStep, completion: (() -> Void)? = nil) {
        self.dispatchGroup.enter()
        launchStep.execute(progress: { [weak self] amount in
            guard let self = self else { return }
            self.progress?((self.totalProgress + amount) / self.numberOfLaunchSteps)
        }, completion: { [weak self] in
            self?.totalProgress += 1.0
            self?.dispatchGroup.leave()
            completion?()
        })
    }
    
}
