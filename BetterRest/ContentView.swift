//
//  ContentView.swift
//  BetterRest
//
//  Created by Joshua Rosado Olivencia on 9/17/24.
//


import CoreML
import SwiftUI


struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack{
            VStack{
                // ========================= Date Picker for wake up time
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                // ========================= Stepper for amount of sleep
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                // ========================= Stepper for coffee daily amount
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in : 1...20)
            }
            
            .navigationTitle("BetterRest")
            
            // =========================  Calculate button
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            // show alert when showingAlert is true
            .alert(alertTitle, isPresented: $showingAlert){
                Button("OK"){} // display a Button saying "OK"
            } message: {
                Text(alertMessage) // Displaying the alert message
            }
        }
        
    }
    func calculateBedTime(){
        do {
            let config = MLModelConfiguration()
            
            
            // Test the ML CORE MODEL
            let model = try SleepCalculator(configuration: config)
            
            // Get components from current calendar [ hour and minute ] from the wakeUp time
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            // Set component hour to be MULT by 60 = 1min MULT by 60 = 1hour. IF FALSE RETURN 0
            let hour = (components.hour ?? 0) * 60 * 60
            // Set component minute to be MULT by 60 = 1 minute. IF FALSE RETURN 0
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // wake up time - actual sleep = time to go to sleep
            let sleepTime = wakeUp - prediction.actualSleep
            
            
            alertTitle = "Your ideal bedtime is..."
            // alert message = displaying hour to go to sleep
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
            
            // return all this if there's an error
        }
        showingAlert = true
    }

}
#Preview {
    ContentView()
}
