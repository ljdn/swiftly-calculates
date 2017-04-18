//
//  GraphViewController.swift
//  Calculator
//
//  Created by lduan on 4/17/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var function: ((Double) -> Double)?
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.function = function
        }
    }
    
}
