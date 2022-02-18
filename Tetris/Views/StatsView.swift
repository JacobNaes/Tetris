//
//  StatsView.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import SwiftUI

struct StatsView: View {
   let currentScore: Int
   
   
   var body: some View {
      Section {
         Text("Current Score: \(currentScore)")
      } header: {
         Label("Stats", systemImage: "person")
      }

   }
}

struct StatsView_Previews: PreviewProvider {
   static var previews: some View {
      List {
         StatsView(currentScore: 100)
      }
   }
}
