//
//  ViewController.swift
//  Calculator
//
//  Created by lduan on 3/31/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    override func viewDidLoad() {
        disableGraph()
    }

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
        disableGraph()
    }

    @IBOutlet weak var graphButton: UIButton!
    func disableGraph() {
        if brain.isPartialResult || brain.description == " " {
            graphButton.isEnabled = false
            graphButton.setTitle("🚫", for: .normal)
        } else {
            graphButton.isEnabled = true
            graphButton.setTitle("📈", for: .normal
            )
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
        disableGraph()
    }
    
    @IBAction func getVar(_ sender: UIButton) {
        brain.setOperand(variableName: "M")
        userIsTyping = false
        displayValue = brain.result!
        disableGraph()
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
        disableGraph()
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
        disableGraph()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationController = segue.destination
        if let navigationController = destinationController as? UINavigationController {
            destinationController = navigationController.visibleViewController ?? destinationController
        }
        
        if let graphViewController = destinationController as? GraphViewController {
            if brain.isPartialResult {
                return
            }
            graphViewController.navigationItem.title = brain.description
            
            graphViewController.function = {
                (x: Double) -> Double in
                self.brain.variableValues["M"] = x
                self.brain.program = self.brain.program
                return self.brain.result ?? 0
            }
        }
    }
    
}

