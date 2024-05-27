
import SwiftUI

struct ContentView: View {
    // Create an instance of HealthKitManager
    let healthKitManager = HealthKitManager()
    
    // State variables to hold the fetched health data
    @State private var activeEnergyBurned: Double = 0.0
    @State private var stepCount: Double = 0.0
    @State private var exerciseTime: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Active Energy Burned: \(activeEnergyBurned)")
            Text("Step Count: \(stepCount)")
            Text("Exercise Time: \(exerciseTime)")
        }
        .onAppear {
            // Request authorization to access HealthKit data
            healthKitManager.requestAuthorization { success, error in
                if success {
                    // Fetch active energy burned data
                    healthKitManager.fetchActiveEnergyBurned { energyBurned, error in
                        if let error = error {
                            print("Error fetching active energy burned: \(error.localizedDescription)")
                        } else {
                            self.activeEnergyBurned = energyBurned
                        }
                    }
                    
                    // Fetch step count data
                    healthKitManager.fetchStepCount { steps, error in
                        if let error = error {
                            print("Error fetching step count: \(error.localizedDescription)")
                        } else {
                            self.stepCount = steps
                        }
                    }
                    
                    // Fetch exercise time data
                    healthKitManager.fetchExerciseTime { exerciseTime, error in
                        if let error = error {
                            print("Error fetching exercise time: \(error.localizedDescription)")
                        } else {
                            self.exerciseTime = exerciseTime
                        }
                    }
                } else {
                    if let error = error {
                        print("HealthKit authorization failed: \(error.localizedDescription)")
                    } else {
                        print("HealthKit authorization failed.")
                    }
                }
            }
        }
    }
}
