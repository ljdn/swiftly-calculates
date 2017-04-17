//
//  GraphDrawer.swift
//  Calculator
//
//  Created by lduan on 4/17/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class GraphView: UIView {

    override func draw(_ rect: CGRect) {
        let origin = CGPoint(x: bounds.minX, y: bounds.maxY)
        
        let axesDrawer = AxesDrawer()
        axesDrawer.drawAxes(in: rect, origin: origin, pointsPerUnit: 50)
    }

}
