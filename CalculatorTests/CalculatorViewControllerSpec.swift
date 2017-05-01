//
//  CalculatorViewControllerSpec.swift
//  Calculator
//
//  Created by lduan on 4/28/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import Quick
import Nimble
@testable import Calculator

class CalculatorViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var calculatorViewController: CalculatorViewController!
        
        beforeEach {
            calculatorViewController = CalculatorViewController()
            expect(calculatorViewController.view).toNot(beNil())
            //expect(calculatorViewController)
        }
        
        it("has a display label") {
            expect(calculatorViewController.display).toNot(beNil())
        }
    }

    
}
