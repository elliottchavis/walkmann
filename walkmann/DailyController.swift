//
//  WeeklyController.swift
//  walkmann
//
//  Created by zee tredded on 2023/01/28.
//

import UIKit


class DailyController: UIViewController {
    
    
    @IBOutlet weak var changeGoalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        configureGesture()
        
    }
    
    // MARK: - Actions
    
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        print("touch")
        //shape.removeFromSuperlayer()

        performSegue(withIdentifier: "goalSegue", sender: self)
        
//        let nav = GoalController()
//        nav.modalPresentationStyle = .popover
//        navigationController?.pushViewController(nav, animated: true)

        //self.present(nav, animated: false, completion: nil)
    }
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .black
        changeGoalLabel?.layer.masksToBounds = true
        changeGoalLabel?.layer.cornerRadius = 10
        
    }
    
    func configureGesture() {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        self.changeGoalLabel?.isUserInteractionEnabled = true
        self.changeGoalLabel?.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(tapGesture(_ :)))
    }
    
    func configureNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Daily"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))

    }
    
    @objc func showProfile(){
        print("this is your profile")
    }
}

