//
//  ViewController.swift
//  Calculator
//
//  Created by lduan on 3/31/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var stepsDisplay: UILabel!
    
    var userIsTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            if digit == "." && display.text!.range(of: ".") != nil {
                return
            } else {
                let textInDisplay = display.text!
                display.text = textInDisplay + digit
            }
        } else {
            display.text = digit
            userIsTyping = true
        }
    }

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var displaySteps: String {
        get {
            return stepsDisplay.text!
        }
        set {
            stepsDisplay.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result!
        }
    }
    
    @IBAction func setVar(_ sender: UIButton) {
        brain.variableValues["M"] = displayValue
        displayValue = brain.result!
    }
    
    @IBAction func getVar(_ sender: UIButton) {
        brain.setOperand(variableName: "M")
        displayValue = brain.result!
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            if mathSymbol == "C" {
                displayValue = 0
                displaySteps = " "
            }
            brain.performOperation(symbol: mathSymbol)
            if brain.isPartialResult {
                displaySteps = "\(brain.description) ..."
            }

        }
        if let result = brain.result {
            if !brain.isPartialResult {
                displaySteps = "\(brain.description) ="
            }
            displayValue = result
        }
    }
    
}

