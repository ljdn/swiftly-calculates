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
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.changeScale(byReactingTo:)))
            graphView.addGestureRecognizer(pinchRecognizer)
            
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.changeView(byReactingTo:)))
            graphView.addGestureRecognizer(panRecognizer)
            
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.changeOrigin(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
        }
    }
    
}
