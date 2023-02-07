//
//  ViewController.swift
//  walkmann
//
//  Created by zee tredded on 2023/01/26.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var activityBoardLabel: UILabel!
    @IBOutlet weak var moveDataLabel: UILabel!
    @IBOutlet weak var stepsDataLabel: UILabel!
    @IBOutlet weak var distanceDataLabel: UILabel!
    
    @IBOutlet weak var goalDataLabel: UILabel!
    @IBOutlet weak var walkmanImage: UIImageView!
    
    let healthStore = HKHealthStore()
    let firstCircle = CAShapeLayer()
    let secondCircle = CAShapeLayer()
    
    let userDefaults = UserDefaults.standard
    
    var ringPercentage: Float = 0.00

    

    
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        if self.userDefaults.object(forKey: "newGoal") != nil {
            let goalValue = userDefaults.object(forKey: "newGoal")
            var stringValue = goalValue as! String
            self.goalDataLabel.text = "\(stringValue)"
            
            
            
            var rect: CGRect = self.moveDataLabel.frame
            rect.size = (self.moveDataLabel.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: self.moveDataLabel.font.fontName , size: self.moveDataLabel.font.pointSize)!]))!
            self.moveDataLabel.frame = rect
            
            healthAuth()

        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureGesture()
        configureUI()
        //healthAuth()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureActivityRing()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Actions
    
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        print("touch")
        //shape.removeFromSuperlayer()

        performSegue(withIdentifier: "Activity", sender: self)
    }
    
    @objc func showProfile(){
        print("show the profile")
    }
    
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .black
        activityBoardLabel?.layer.masksToBounds = true
        activityBoardLabel?.layer.cornerRadius = 15
        
        var rect: CGRect = self.moveDataLabel.frame
        rect.size = (self.moveDataLabel.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: self.moveDataLabel.font.fontName , size: self.moveDataLabel.font.pointSize)!]))!
        self.moveDataLabel.frame = rect
        
        
    }
    
    func configureActivityRing() {
        
        let bottomCirclePath = UIBezierPath(arcCenter: walkmanImage.center, radius: 76, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        firstCircle.path = bottomCirclePath.cgPath
        firstCircle.lineWidth = 20
        firstCircle.strokeColor = UIColor.darkGray.cgColor
        firstCircle.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(firstCircle)
        
        let topCirclePath = UIBezierPath(arcCenter: walkmanImage.center, radius: 76, startAngle: 0, endAngle: (.pi * 2) * CGFloat(ringPercentage), clockwise: true)
        secondCircle.path = topCirclePath.cgPath
        secondCircle.lineWidth = 20
        secondCircle.strokeColor =  UIColor.systemOrange.cgColor
        secondCircle.fillColor = UIColor.clear.cgColor
        secondCircle.strokeEnd = 0
        secondCircle.cornerRadius = 10
        view.layer.addSublayer(secondCircle)
        
        // animate second(top) circle
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 0.9
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        secondCircle.add(animation, forKey: "animation")
        
    }
    
    func configureGesture() {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        self.activityBoardLabel.isUserInteractionEnabled = true
        self.activityBoardLabel.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(tapGesture(_ :)))
    }
    
    func healthAuth() {
        
        // Access Step Count
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)! , HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!]
        
        // Check for Authorization
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if (bool) {
                // Authorization Successful
                self.getSteps { (result) in
                    DispatchQueue.main.async {
                        let stepCount = String(Int(result))
                        self.stepsDataLabel.text = String(stepCount)
                    }
                }
                
                self.getDistance { (result) in
                    DispatchQueue.main.async {
                        let finalResult = result * 0.000189394
                        let distanceCount = String(format: "%.2f", finalResult)
                        self.distanceDataLabel.text = "\(distanceCount) miles"
                    }
                }
                
                self.getCalories { (result) in
                    DispatchQueue.main.async {
                        let caloricCount = String(Int(result))
                        
                         // Read/Get Boolean from User Defaults
                        if self.userDefaults.object(forKey: "newGoal") == nil {
                            self.moveDataLabel.text = "\(caloricCount)/"
                            
                            var calGoal: Float = 100.00
                            var calAchieved = Float(result)
                            var percentage = calAchieved / calGoal
                            print(" Percetage of goal: \(percentage)")
                            self.ringPercentage = percentage
                        } else {
                            var goalValue = self.userDefaults.object(forKey: "newGoal")
                            
                            let stringValue = goalValue as! String
                            self.moveDataLabel.text = "\(caloricCount)/"
                            var rect: CGRect = self.moveDataLabel.frame
                            rect.size = (self.moveDataLabel.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: self.moveDataLabel.font.fontName , size: self.moveDataLabel.font.pointSize)!]))!
                            self.moveDataLabel.frame = rect
                            
                            
                            self.goalDataLabel.text = "\(stringValue)"
                            
                            var calGoal = Float(stringValue)
                            var calAchieved = Float(result)
                            var percentage = calAchieved / calGoal!
                            print(" Percetage of goal: \(percentage)")
                            self.ringPercentage = percentage

                        }
                    }
                }
            }
        }
    }
    
    
    func getSteps(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                               quantitySamplePredicate: nil,
                                               options: [.cumulativeSum],
                                               anchorDate: startOfDay,
                                               intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in

                if let sum = statistics.sumQuantity() {
                    // Get distance (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.count())
                } // end if

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            } // end if
        }
        
        healthStore.execute(query)

    }
    
    
    
    func getDistance(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                               quantitySamplePredicate: nil,
                                               options: [.cumulativeSum],
                                               anchorDate: startOfDay,
                                               intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in

                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.foot())
                } // end if

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.foot())
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            } // end if
        }
        
        healthStore.execute(query)

    }
    
    
    
    
    func getCalories(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                               quantitySamplePredicate: nil,
                                               options: [.cumulativeSum],
                                               anchorDate: startOfDay,
                                               intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in

                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                } // end if

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            } // end if
        }
        
        healthStore.execute(query)

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
        navigationItem.title = "Summary"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))

    }
    
    
    



}

