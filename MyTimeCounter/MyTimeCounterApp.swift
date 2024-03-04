//
//  MyTimeCounterApp.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 16/2/22.
//

import SwiftUI

@main
struct MyTimeCounterApp: App {
    @StateObject var model = MyDatesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MyDatesViewModel())
        }
    }
}
