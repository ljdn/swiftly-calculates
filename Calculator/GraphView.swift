//
//  GraphDrawer.swift
//  Calculator
//
//  Created by lduan on 4/17/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

@IBDesignable
public class GraphView: UIView {
    
    var function: ((Double) -> Double)? {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    public var origin = CGPoint(x: 0, y: 0) {
        didSet { setNeedsDisplay() }
    }
    
    var noOriginSet = true
    
    @IBInspectable
    public var scale: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    public var color = UIColor.black {
        didSet { setNeedsDisplay() }
    }

    override public func draw(_ rect: CGRect) {
        
        if noOriginSet {
            origin = CGPoint(x: bounds.midX, y: bounds.midY)
            noOriginSet = false
        }
        
        let axesDrawer = AxesDrawer()
        axesDrawer.drawAxes(in: rect, origin: origin, pointsPerUnit: scale)
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = 2
        var firstPoint = true

        if function != nil {
            for x in 0...Int(bounds.size.width * scale) {
                let pointX = CGFloat(x) / scale
                
                let xVal = Double((pointX - origin.x) / scale)
                let yVal = function!(xVal)
                
                if !yVal.isZero && !yVal.isNormal {
                    firstPoint = true
                    continue
                }
                
                let pointY = origin.y - CGFloat(yVal) * scale
                
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
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .ended, .changed:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func changeView(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .ended, .changed:
            let distance = panRecognizer.translation(in: self)
            origin = CGPoint(x: origin.x + distance.x, y: origin.y + distance.y)
            panRecognizer.setTranslation(CGPoint.zero, in: self)
        default:
            break
        }
    }
    
    func changeOrigin(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            origin = tapRecognizer.location(in: self)
        }
    }

}
