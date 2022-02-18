//
//  TetrisView.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import SwiftUI

struct TetrisView: View {
   @StateObject var viewModel = TetrisViewModel()
   
   var body: some View {
      NavigationView {
         List {
            StatsView(currentScore: viewModel.score)
            SettingsView(popSize: $viewModel.populationSize, mutationRate: $viewModel.mutationRate, numElites: $viewModel.eliteSize, speed: $viewModel.speed)
         }
         
         VStack {
            if viewModel.isLoading {
               ProgressView("Calculating")
            } else {
               VStack {
                  GeometryReader { geo in
                     BoardView(
                        geoProxy: geo,
                        rows: viewModel.rows,
                        columns: viewModel.columns,
                        board: viewModel.board,
                        tetromino: viewModel.currentPiece
                     )
                  }
               }
            }
         }
         .navigationTitle("Tetris AI")
         .toolbar {
            ToolbarItem(placement: .primaryAction) {
               Button("Simulate") {
                  Task {
                     await viewModel.nextGeneration()
                  }
               }
            }
            
            ToolbarItem(placement: .primaryAction) {
               Button("Reset") {
                  Task {
                     await viewModel.reset()
                  }
               }
            }
         }
      }
   }
}

struct TetrisView_Previews: PreviewProvider {
   static var previews: some View {
      TetrisView()
   }
}
