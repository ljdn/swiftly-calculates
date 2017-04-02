//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by lduan on 3/31/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator: Double?
    
    func performOperation(_ symbol: String) {
        switch symbol {
        case "π":
            accumulator = Double.pi
        case "√":
            if let operand = accumulator {
                accumulator = sqrt(operand)
            }
        default:
            break
        }
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        return accumulator;
    }
    
}
