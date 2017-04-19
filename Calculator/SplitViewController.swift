//
//  SplitViewController.swift
//  Calculator
//
//  Created by lduan on 4/19/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
