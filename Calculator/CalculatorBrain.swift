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
    private var internalProgram = [AnyObject]()
    
    var variableValues = [String: Double]()
    
    private enum Operation {
        enum TypeOfUnary {
            case before
            case after
        }
        
        case constant(Double)
        case unary(function: ((Double) -> Double), format: TypeOfUnary)
        case binary((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unary(function: sqrt, format: .before),
        "±" : Operation.unary(function: ({-$0}), format: .before),
        "^2" : Operation.unary(function: ({$0 * $0}), format: .after),
        "sin" : Operation.unary(function: (sin), format: .before),
        "cos" : Operation.unary(function: (cos), format: .before),
        "tan" : Operation.unary(function: (tan), format: .before),
        "×" : Operation.binary(*),
        "÷" : Operation.binary(/),
        "+" : Operation.binary(+),
        "-" : Operation.binary(-),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unary(let function, _):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binary(let function):
                if accumulator != nil {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperationInfo(function: function, firstOperand: accumulator!, symbol: symbol)
                }
            case .equals:
                if pendingBinaryOperation != nil {
                    performPendingBinaryOperation()
                }
            case .clear :
                clearCalculator()
            }
        }
    }
    
    private func clearCalculator() {
        pendingBinaryOperation = nil
        accumulator = nil
        internalProgram.removeAll()
        variableValues = [:]
    }
    
    private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.function(pendingBinaryOperation!.firstOperand, accumulator!)
            pendingBinaryOperation = nil
        }
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
    
    func setOperand(variableName: String) {
        variableValues[variableName] = variableValues[variableName] ?? 0.0
        accumulator = variableValues[variableName]
        internalProgram.append(variableName as AnyObject)
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
    
    var description: String {
        var opSequence: String = ""
        for opIndex in internalProgram.indices {
            if internalProgram[opIndex] is Double {
                opSequence += String(describing: internalProgram[opIndex])
            } else if let symbol = internalProgram[opIndex] as? String {
                if let operation = (operations[symbol]) {
                    switch operation {
                    case .constant, .binary:
                        opSequence += " \(internalProgram[opIndex]) "
                    case .unary(_, .before):
                        if internalProgram[opIndex-1] as? String == "=" {
                            opSequence = symbol + "(" + opSequence + ")"
                        } else {
                            let firstPartArray = internalProgram[0..<opIndex-1].map({String(describing: $0)})
                            let firstPartOfString = firstPartArray.joined(separator: " ")
                            opSequence = firstPartOfString + symbol + "(\(internalProgram[opIndex-1]))"
                        }
                    case .unary(_, .after):
                        if internalProgram[opIndex-1] as? String == "=" {
                            opSequence = "(" + opSequence + ")" + symbol
                        } else {
                            let firstPartArray = internalProgram[0..<opIndex-1].map({String(describing: $0)})
                            let firstPartOfString = firstPartArray.joined(separator: " ")
                            opSequence = firstPartOfString + "(\(internalProgram[opIndex-1]))" + symbol
                        }
                    default:
                        break
                    }
                } else {
                    opSequence += symbol
                }
            }
        }
        return opSequence
    }
    
    var result: Double? {
        return accumulator;
    }
    
}
