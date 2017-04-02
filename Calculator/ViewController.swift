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
    
    var userIsTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
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
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
}

