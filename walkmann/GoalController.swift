//
//  GoalController.swift
//  walkmann
//
//  Created by zee tredded on 2023/02/03.
//

import UIKit

class GoalController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.backgroundColor = .systemOrange
        stepper.value = 100
        stepper.minimumValue = 10
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        countLabel.text = Int(sender.value).description
    }
    
    
}
