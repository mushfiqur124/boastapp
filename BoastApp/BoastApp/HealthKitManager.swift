//
//  HealthKitManager.swift
//  BoastApp
//
//  Created by Mushfiqur Rahman on 2024-05-26.
//

import HealthKit

class HealthKitManager {
    
    let healthStore = HKHealthStore()
    
    // Types to read from HealthKit
    let readDataTypes: Set<HKSampleType> = [
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
    ]
    
    // Request authorization to access HealthKit data
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) in
            completion(success, error)
        }
    }
    
    // Fetch calories burned data
    func fetchActiveEnergyBurned(completion: @escaping (Double, Error?) -> Void) {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(0, nil)
            return
        }
        
        fetchData(for: energyType, completion: completion)
    }
    
    // Fetch step count data
    func fetchStepCount(completion: @escaping (Double, Error?) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0, nil)
            return
        }
        
        fetchData(for: stepType, completion: completion)
    }
    
    // Fetch exercise time data
    func fetchExerciseTime(completion: @escaping (Double, Error?) -> Void) {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(0, nil)
            return
        }
        
        fetchData(for: exerciseType, completion: completion)
    }
    
    // Generic method to fetch data
    private func fetchData(for quantityType: HKQuantityType, completion: @escaping (Double, Error?) -> Void) {
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            var resultCount = 0.0
            
            if let sum = result?.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
            }
            
            DispatchQueue.main.async {
                completion(resultCount, error)
            }
        }
        
        healthStore.execute(query)
    }
}
