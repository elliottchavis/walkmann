//
//  GoalController.swift
//  walkmann
//
//  Created by zee tredded on 2023/02/03.
//

import UIKit

class GoalController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var changeGoalBtn: UIButton!
    
    let userDefaults = UserDefaults.standard

    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Actions
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        countLabel.text = Int(sender.value).description
        
        userDefaults.set(countLabel.text, forKey: "newGoal")
        print(userDefaults.object(forKey: "newGoal"))
    }
    
    @IBAction func changeGoalPressed(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        stepper.backgroundColor = .systemOrange
        stepper.minimumValue = 10
        stepper.layer.cornerRadius = 10
        
        if // Read/Get Boolean from User Defaults
            userDefaults.object(forKey: "newGoal") == nil {
            stepper.value = 100
            print("ConfigureUI, userDefaults is not empty it's, ", userDefaults.object(forKey: "newGoal"))

        } else {
            let goalValue = userDefaults.object(forKey: "newGoal")
            
            var stringValue = goalValue as! String
            countLabel.text = stringValue
            
            var doubleValue = Double(stringValue)
            stepper.value = doubleValue!
        }
        
        changeGoalBtn.layer.cornerRadius = 10
    }
    
}
