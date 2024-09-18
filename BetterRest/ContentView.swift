//
//  ContentView.swift
//  BetterRest
//
//  Created by Joshua Rosado Olivencia on 9/17/24.
//



import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Section{
                RadialGradient(colors: [.cyan.opacity(0.1), .pink], center: .center , startRadius: 100, endRadius: 2000)
                    .ignoresSafeArea()
            }
            VStack{
                Text("BetterRest").font(.system(size: 30)).bold().foregroundStyle(.teal)
                Text("loading...").foregroundStyle(.secondary)
                    
            }
        }
        
        
    }
}
#Preview {
    ContentView()
}
