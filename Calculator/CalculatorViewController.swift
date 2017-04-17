//
//  ViewController.swift
//  Calculator
//
//  Created by lduan on 3/31/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

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
    
    @IBAction func storeVar(_ sender: UIButton) {
        brain.variableValues["M"] = displayValue
        userIsTyping = false
        brain.program = brain.program
        displayValue = brain.result!
    }
    
    @IBAction func getVar(_ sender: UIButton) {
        brain.setOperand(variableName: "M")
        userIsTyping = false
        displayValue = brain.result!
    }
    
    @IBAction func undo(_ sender: UIButton) {
        if userIsTyping && display.text! != "0.0" {
            display.text! = display.text!.substring(to: display.text!.index(before: display.text!.endIndex))
            if display.text!.isEmpty {
                displayValue = 0.0
                userIsTyping = false
            }
        } else {
            brain.undo()
            displaySteps = brain.description 
            displayValue = brain.result ?? 0.0
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationController = segue.destination
        if let navigationController = destinationController as? UINavigationController {
            destinationController = navigationController.visibleViewController ?? destinationController
        }
        
        if let graphViewController = destinationController as? GraphViewController {
            let identifier = segue.identifier
        }
    }
    
}

