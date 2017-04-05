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
    private var lastConstant: String?
    private var internalProgram = [AnyObject]()
    var description = " "
    
    private enum TypeOfOperation {
        case constantOperation
        case unaryPrefix
        case unaryPostfix
        case binaryOperation
        case equalsOperation
        case clearOperation
    }
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private typealias OperationWithType = (operation: Operation, type: TypeOfOperation)
    
    private var operations: Dictionary<String, OperationWithType> = [
        "π" : (Operation.constant(Double.pi), TypeOfOperation.constantOperation),
        "e" : (Operation.constant(M_E), TypeOfOperation.constantOperation),
        "√" : (Operation.unary(sqrt), TypeOfOperation.unaryPrefix),
        "±" : (Operation.unary({-$0}), TypeOfOperation.unaryPrefix),
        "^2" : (Operation.unary({$0 * $0}), TypeOfOperation.unaryPostfix),
        "sin" : (Operation.unary(sin), TypeOfOperation.unaryPrefix),
        "cos" : (Operation.unary(cos), TypeOfOperation.unaryPrefix),
        "tan" : (Operation.unary(tan), TypeOfOperation.unaryPrefix),
        "×" : (Operation.binary(*), TypeOfOperation.binaryOperation),
        "÷" : (Operation.binary(/), TypeOfOperation.binaryOperation),
        "+" : (Operation.binary(+), TypeOfOperation.binaryOperation),
        "-" : (Operation.binary(-), TypeOfOperation.binaryOperation),
        "=" : (Operation.equals, TypeOfOperation.equalsOperation),
        "C" : (Operation.clear, TypeOfOperation.clearOperation)
    ]
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operationWithType = operations[symbol] {
            switch operationWithType.operation {
            case .constant(let value):
                lastConstant = symbol
                if pendingBinaryOperation != nil {
                    performPendingBinaryOperation()
                } else {
                    accumulator = value
                    description += symbol
                }
            case .unary(let function):
                if pendingBinaryOperation != nil {
                    description += pendingBinaryOperation!.symbol
                }
                if accumulator != nil {
                    if operationWithType.type == .unaryPrefix {
                        description += "\(symbol)(\(accumulator!))"
                    } else if operationWithType.type == .unaryPostfix {
                        description += "(\(accumulator!))\(symbol)"
                    }
                    accumulator = function(accumulator!)
                }
                lastConstant = nil
            case .binary(let function):
                if accumulator != nil {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperationInfo(function: function, firstOperand: accumulator!, symbol: symbol)
                }
            case .equals:
                if pendingBinaryOperation != nil {
                    performPendingBinaryOperation()
                }
                lastConstant = nil
            case .clear :
                clearCalculator()
            }
        }
    }
    
    private func clearCalculator() {
        pendingBinaryOperation = nil
        description = " "
        accumulator = nil
        lastConstant = nil
        internalProgram.removeAll()
    }
    
    private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if description == " " {
                description = String(describing: pendingBinaryOperation!.firstOperand)
            }
            
            if lastConstant != nil {
                description += " \(pendingBinaryOperation!.symbol) \(lastConstant!)"
            } else {
                description += " \(pendingBinaryOperation!.symbol) \(accumulator!)"
            }
            accumulator = pendingBinaryOperation!.function(pendingBinaryOperation!.firstOperand, accumulator!)
            pendingBinaryOperation = nil
            
        } else {
            if lastConstant != nil {
                description = lastConstant!
            } else {
                description = String(accumulator!)
            }
        }
        lastConstant = nil
    }
    
    private var pendingBinaryOperation: PendingBinaryOperationInfo?
    
    var isPartialResult: Bool {
        return pendingBinaryOperation != nil
    }
    
    private struct PendingBinaryOperationInfo {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let symbol: String
    }
    
    func setOperand(_ operand: Double) {
        if pendingBinaryOperation == nil {
            clearCalculator()
        }
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clearCalculator()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    var result: Double? {
        return accumulator;
    }
    
}
