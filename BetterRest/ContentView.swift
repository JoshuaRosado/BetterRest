//
//  ContentView.swift
//  BetterRest
//
//  Created by Joshua Rosado Olivencia on 9/17/24.
//

// ==========================================================


// CORE ML = let's us use machine learning models in our app to make predictions

// CREATE ML = let's us create custom machine learning models with our own data


// Tabular Regression = Throwing a whole bunch of spread sheets data at CREATE ML and ask it to figure out the different relationship of various values for us


// ML 2 STEPS

// Step 1 : We train the model with CREATE ML
// Step 2 : Ask model to make prediction with CORE ML

// ==========================================================

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("BetterRest").font(.system(size: 30)).bold().foregroundStyle(.teal)
        Text("loading...").foregroundStyle(.secondary)
        
    }
}
#Preview {
    ContentView()
}
