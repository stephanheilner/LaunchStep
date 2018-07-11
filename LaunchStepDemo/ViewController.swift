//
//  ViewController.swift
//  LaunchStepDemo
//
//  Created by Stephan Heilner on 7/11/18.
//  Copyright © 2018 Stephan Heilner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Made it!"
        view.addSubview(label)
    }


}

