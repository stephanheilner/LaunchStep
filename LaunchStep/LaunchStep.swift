//
//  LaunchStep.swift
//  LaunchStep
//
//  Created by Stephan Heilner on 7/10/18.
//

import Foundation

public protocol LaunchStep {
    func showProgress() -> Bool
    func shouldRun() -> Bool
    func execute(progress: @escaping (Float) -> Void, completion: @escaping () -> Void)
}

public extension LaunchStep {
    func showProgress() -> Bool {
        return true
    }
    func shouldRun() -> Bool {
        return true
    }
}
