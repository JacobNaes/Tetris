//
//  TetrisViewModel.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Combine
import Foundation

class TetrisViewModel: ObservableObject {
   @Published private var tetrisSimulator: TetrisSimulator = TetrisSimulator(moves: [], tetrominos: [])
   @Published private (set) var isLoading: Bool = false
   @Published private (set) var tetrominoPieces: [Tetromino]
   
   @Published var populationSize: Int
   @Published var mutationRate: Double
   @Published var eliteSize: Int
   @Published var speed: Double
   
   
   private var geneticAlgorithm: GeneticAlgorithm
   private (set) var rows: Int
   private (set) var columns: Int
   private var timer: Timer?
   
   
   var board: [[BlockType?]] {
      tetrisSimulator.board.grid
   }
   
   var currentPiece: Tetromino? {
      tetrisSimulator.tetromino
   }
   
   var pieceCount: Int {
      tetrisSimulator.piecesPlaced
   }
   
   var score: Int {
      tetrisSimulator.score
   }
   
   
   init() {
      let numRows = 23
      let numColumns = 10
      let numPieces = 20_000
      let tetrominos = Tetromino.createTetrominoBag(size: numPieces, numRows: numRows, numColumns: numColumns)
      let popSize = 5
      let mutateRate = 0.01
      let eliteSize = 1
      let speed = 0.01
      
      self.tetrominoPieces = tetrominos
      self.rows = numRows
      self.columns = numColumns
      self.populationSize = popSize
      self.mutationRate = mutateRate
      self.eliteSize = eliteSize
      self.speed = speed
      self.geneticAlgorithm = GeneticAlgorithm(
         rows: rows,
         columns: columns,
         tetrominos: tetrominos,
         popSize: popSize,
         mRate: mutateRate,
         numElites: eliteSize
      )
   }
   
   
   private func initializeGeneticAlgorithm() async {
      await geneticAlgorithm.initializePopulation()
   }
   
   
   func nextGeneration() async {
      DispatchQueue.main.async {
         self.isLoading = true
      }
      
      if geneticAlgorithm.population.count == 0 {
         await initializeGeneticAlgorithm()
      }
      
      await geneticAlgorithm.nextGeneration()
      let moves = geneticAlgorithm.population
         .sorted { $0.fitness > $1.fitness }
         .first
         .map { $0.moveSequence } ?? []
      
      DispatchQueue.main.async {
         self.tetrisSimulator = TetrisSimulator(moves: moves, tetrominos: self.tetrominoPieces)
         self.runGames()
         self.isLoading = false
      }
   }
   
   
   private func simulateBoard(timer: Timer) {
      self.tetrisSimulator.simulateBoard {
         self.timer?.invalidate()
      }
      self.objectWillChange.send()
   }
   
   
   private func runGames() {
      timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: simulateBoard(timer:))
   }
   
   func reset() async {
      
   }
}
