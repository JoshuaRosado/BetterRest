//
//  ContentView.swift
//  BetterRest
//
//  Created by Joshua Rosado Olivencia on 9/17/24.
//


import CoreML
import SwiftUI


struct ContentView: View {
    // displaying an average time of wakeup in the datePicker
    // for this to work it has to be a STATIC VAR ***
    @State private var wakeUp = defaultWakeTime
    
    
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    // STATIC VAR
    static var defaultWakeTime: Date {
        var components = DateComponents() // Using components
        components.hour = 7 // adding hour component
        components.minute = 0 // adding minute component
        // return the current calendar date from the component added previously. If it doesn't return anything then RETURN current time
        return Calendar.current.date(from: components) ?? .now
    }
    
    
    
    var body: some View {
        NavigationStack{
            Form{ // adding a standard form to fix the position of the every element inside
                VStack(alignment: .leading, spacing:0){
                    // ========================= Date Picker for wake up time
                    
                    // Display question
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    // Display Options, with the wakeUp average time showing.
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing:0){
                    // ========================= Stepper for amount of sleep
                    
                    // Display Question
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    // Display a counter option to select how many hours are desired for sleeping
                    // displaying average var
                    // steps = amount of range you want to be scale
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                    // ========================= Stepper for coffee daily amount
                HStack{
                    
                    
                    // Display question
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    
                    // Display a counter option to select how many cups of coffee the user has consumed
                    // displaying the average amount Var
//                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in : 1...20)
                    
                    Picker("", selection: $coffeeAmount){
                        ForEach(0..<21){number in
                            Text("\(number)")}
                    }
                    .pickerStyle(.menu)
                    
                    // ^[\(coffeeAmount) cup](inflect: true) reads as
                    // SwiftUI has to update from single to plural depending on the variable output. If 1 then "cup", else if 2 or more then "cups"
                }
                HStack(alignment: .center){
                    Spacer()
                    Image(systemName: "moon").font(.system(size: 60)).foregroundStyle(.blue.opacity(0.1))
                    Spacer()
                    Text("Get some rest").bold().fontDesign(.rounded).foregroundStyle(.blue.opacity(0.3))
                    Spacer()
                }
            }
            // Main title
            .navigationTitle("BetterRest")
            
            // =========================  Calculate button
            // Button that invokes the func
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
