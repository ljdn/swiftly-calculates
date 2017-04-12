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
    private var internalProgram = [TypeOfOp]()
    
    var variableValues = [String: Double]()
    
    private enum TypeOfOp {
        case operand(Double)
        case operation(String)
        case variable(String)
    }
    
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
        "C" : Operation.clear,
    ]
    
    func performOperation(symbol: String) {
        internalProgram.append(TypeOfOp.operation(symbol))
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
            case .clear:
                clearCalculator()
            }
        }
    }
    
    func undo() {
        if !internalProgram.isEmpty {
            internalProgram.removeLast()
        }
        program = internalProgram as CalculatorBrain.PropertyList
    }
    
    private func internalToString(_ op: TypeOfOp) -> String {
        switch op {
        case .operand(let value):
            return String(value)
        case .operation(let symbol):
            return symbol
        case .variable(let variableName):
            return variableName
        }
    }
    
    private func clearCalculator() {
        clearKeepVar()
        variableValues = [:]
    }
    
    private func clearKeepVar() {
        pendingBinaryOperation = nil
        accumulator = nil
        internalProgram.removeAll()
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
            clearKeepVar()
        }
        accumulator = operand
        internalProgram.append(TypeOfOp.operand(operand))
    }
    
    func setOperand(variableName: String) {
        accumulator = variableValues[variableName] ?? 0
        internalProgram.append(TypeOfOp.variable(variableName))
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            pendingBinaryOperation = nil
            accumulator = nil
            internalProgram.removeAll()
            if let arrayOfOps = newValue as? [TypeOfOp] {
                for op in arrayOfOps {
                    switch op {
                    case .operand(let operand):
                        setOperand(operand)
                    case .operation(let symbol):
                        performOperation(symbol: symbol)
                    case .variable(let variableName):
                        setOperand(variableName: variableName)
                    }
                }
            }
        }
    }
    
    var description: String {
        var opSequence: String = ""
        for opIndex in internalProgram.indices {
            switch internalProgram[opIndex] {
            
            case .operand(let operand):
                opSequence += String(describing: operand)
            case .variable(let variableName):
                opSequence += variableName
            case .operation(let symbol):
                if let operation = (operations[symbol]) {
                    switch operation {
                    case .constant, .binary:
                        opSequence += " \(symbol) "
                    case .unary(_, .before):
                        if case .operation("=") = internalProgram[opIndex-1] {
                            opSequence = symbol + "(" + opSequence + ")"
                        } else {
                            let firstPartArray = internalProgram[0..<opIndex-1].map({internalToString($0)})
                            let firstPartOfString = firstPartArray.joined(separator: " ")
                            opSequence = firstPartOfString + symbol + " (\(internalToString(internalProgram[opIndex-1])))"
                        }
                    case .unary(_, .after):
                        if case .operation("=") = internalProgram[opIndex-1] {
                            opSequence = "(" + opSequence + ")" + symbol
                        } else {
                            let firstPartArray = internalProgram[0..<opIndex-1].map({internalToString($0)})
                            let firstPartOfString = firstPartArray.joined(separator: " ")
                            opSequence = firstPartOfString + " (\(internalToString(internalProgram[opIndex-1]))) " + symbol + " "
                        }
                    default:
                        break
                    }
                }
            }
        }
        return opSequence
    }
    
    var result: Double? {
            return accumulator;
    }
    
}
