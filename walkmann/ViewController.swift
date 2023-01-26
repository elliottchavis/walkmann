//
//  ViewController.swift
//  walkmann
//
//  Created by zee tredded on 2023/01/26.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var activityBoardLabel: UILabel!
    @IBOutlet weak var moveDataLabel: UILabel!
    @IBOutlet weak var stepsDataLabel: UILabel!
    @IBOutlet weak var distanceDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureUI()
        
    }
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .black
        activityBoardLabel?.layer.masksToBounds = true
        activityBoardLabel?.layer.cornerRadius = 15
    }


}

