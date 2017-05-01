//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by lduan on 4/26/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import Quick
import Nimble
@testable import Calculator

class CalculatorTests: QuickSpec {
    
    override func spec() {
        describe("Setting up Quick and Nimble for testing using Carthage") {
            it("is not very hard") {
                expect(true).to(beTruthy())
            }
            
            it("works very well") {
                expect(20 * 2 + 3 - 1).to(equal(42))
            }
        }
        
        describe("calculator brain") {
            var brain: CalculatorBrain?
            
            beforeEach {
                brain = CalculatorBrain()
            }
            
            describe("operations") {
                it("should set partial result to true") {
                    brain!.setOperand(1.0)
                    brain!.performOperation(symbol: "+")
                    expect(brain!.isPartialResult).to(beTruthy())
                }
                
                it ("should return 2") {
                    brain!.setOperand(1)
                    brain!.performOperation(symbol: "+")
                    brain!.setOperand(1)
                    brain!.performOperation(symbol: "=")
                    
                    expect(brain!.result).to(equal(2.0))
                }
            }
            
            describe("description") {
                it("should format unary operators correctly") {
                    brain?.setOperand(9)
                    brain?.performOperation(symbol: "√")
                    
                    expect(brain?.description).to(equal("√ (9.0)"))
                }
                
                it("should format binary operations correctly") {
                    brain!.setOperand(1)
                    brain!.performOperation(symbol: "+")
                    brain!.setOperand(1)
                    brain!.performOperation(symbol: "=")
                    
                    expect(brain?.description).to(equal(" 1.0 + 1.0"))
                }
            }
        }
        
    }
    
}
