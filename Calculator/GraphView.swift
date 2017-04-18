//
//  GraphDrawer.swift
//  Calculator
//
//  Created by lduan on 4/17/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    var function: ((Double) -> Double)? {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var origin = CGPoint(x: 0, y: 0) {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var scale: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var color = UIColor.black {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        
        origin = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let axesDrawer = AxesDrawer()
        axesDrawer.drawAxes(in: rect, origin: origin, pointsPerUnit: scale)
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = 2
        var firstPoint = true

        if function != nil {
            for x in 0...Int(bounds.size.width * scale) {
                let pointX = CGFloat(x) / scale
                
                let xVal = Double(pointX - origin.x)
                let yVal = function!(xVal)
                
                let pointY = (origin.y - CGFloat(yVal)) / scale
                
                if firstPoint {
                    path.move(to: CGPoint(x: pointX, y: pointY))
                    firstPoint = false
                } else {
                    path.addLine(to: CGPoint(x: pointX, y: pointY))
                    
                }
            }
        }
        path.stroke()
    }

}
