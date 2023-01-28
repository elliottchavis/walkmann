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
    
    @IBOutlet weak var walkmanImage: UIImageView!
    
    let healthStore = HKHealthStore()
    let shape = CAShapeLayer()

    
    
    // MARK: - LifeCycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGesture()
        configureUI()
        healthAuth()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureActivityRing()

    }
    
    // MARK: - Actions
    
    
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        print("touch")
        shape.removeFromSuperlayer()

        performSegue(withIdentifier: "Activity", sender: self)
    }
    
    
    // MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .black
        activityBoardLabel?.layer.masksToBounds = true
        activityBoardLabel?.layer.cornerRadius = 15
        
        
    }
    
    func configureActivityRing() {
        let circlePath = UIBezierPath(arcCenter: walkmanImage.center, radius: 76, startAngle: 0, endAngle: .pi, clockwise: true)
        shape.path = circlePath.cgPath
        shape.lineWidth = 20
        shape.strokeColor =  UIColor.systemOrange.cgColor
        view.layer.addSublayer(shape)
        
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
                        print(distanceCount)
                        self.distanceDataLabel.text = "\(distanceCount) miles"
                    }
                }
                
                self.getCalories { (result) in
                    DispatchQueue.main.async {
                        let caloricCount = String(Int(result))
                        self.moveDataLabel.text = "\(caloricCount)/300cal"
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
    
    
    
    
    
    



}

