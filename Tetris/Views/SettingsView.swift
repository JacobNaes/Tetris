//
//  SettingsView.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import SwiftUI

struct SettingsView: View {
   @Binding var popSize: Int
   @Binding var mutationRate: Double
   @Binding var numElites: Int
   @Binding var speed: Double
   
   var body: some View {
      Section {
         Stepper(value: $speed, in: 0.005...1, step: 0.005) {
            Text("Simulation Speed: \(speed.formatted(.number.precision(.fractionLength(3))))")
         }
         Stepper(value: $popSize, in: 1...20, step: 1) {
            Text("Population Size: \(popSize)")
         }
         Stepper(value: $mutationRate, in: 0.01...1, step: 0.01) {
            Text("Mutation Rate: \(mutationRate.formatted(.number.precision(.fractionLength(2))))")
         }
      } header: {
         Label("Settings", systemImage: "gear")
      }
   }
}

struct SettingsView_Previews: PreviewProvider {
   static var previews: some View {
      List {
         SettingsView(popSize: .constant(Int(0.01)), mutationRate: .constant(5), numElites: .constant(Int(0.01)), speed: .constant(1))
      }
   }
}
