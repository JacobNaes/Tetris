//
//  TetrisSimulator.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation
import Combine

class TetrisSimulator: ObservableObject {
   @Published private (set) var board: Board = Board()
   @Published private (set) var tetromino: Tetromino?
   @Published private (set) var score: Int = 0
   @Published private (set) var piecesPlaced: Int = 0
   @Published private (set) var bag: [Tetromino]
   @Published private (set) var gameOver: Bool = false
   
   private var moves: [Move]
   
   
   init(moves: [Move], tetrominos: [Tetromino]) {
      self.moves = moves
      self.bag = tetrominos
   }
   
   func simulateBoard(completion: () -> Void) {
      board.grid = board.clearLines { numLines in
         score += getPoints(numCleared: numLines)
      }
      
      if tetromino == nil {
         guard !bag.isEmpty else { return }
         self.tetromino = bag.removeFirst()

         if isValid(tetromino: tetromino!) && !moves.isEmpty {
            moveToPosition(move: moves.removeFirst())
            return
         } else {
            gameOver = true
            completion()
            return
         }
      }
      
      if moveTetrominoDown() {
         return
      }
      
      placeTetromino(tetromino: tetromino!)
      tetromino = nil
      piecesPlaced += 1
   }
   
   
   private func moveToPosition(move: Move) {
      guard tetromino != nil else { return }
      for _ in 0..<move.rotations { rotateTetromino() }
      for _ in 0..<move.right { moveTetrominoRight() }
      for _ in 0..<move.left { moveTetrominoLeft() }
   }
   
   
   private  func moveTetrominoDown() -> Bool {
      let success = moveTetromino(dx: 0, dy: 1)
      return success
   }
   
   private func moveTetrominoRight() {
      moveTetromino(dx: 1, dy: 0)
   }
   
   private func moveTetrominoLeft() {
      moveTetromino(dx: -1, dy: 0)
   }
   
   private func rotateTetromino() {
      guard let tetromino = self.tetromino else { return }
      let newTetromino = tetromino.rotate()
      if isValid(tetromino: newTetromino) {
         self.tetromino = newTetromino
      }
   }
   
   @discardableResult
   private func moveTetromino(dx: Int, dy: Int) -> Bool {
      guard let tetromino = self.tetromino else { return false }
      let newTetromino = tetromino.move(dx: dx, dy: dy)
      if isValid(tetromino: newTetromino) {
         self.tetromino = newTetromino
         return true
      }
      return false
   }
   
   private func placeTetromino(tetromino: Tetromino) {
      for block in tetromino.blocks {
         let row = tetromino.origin.row + block.row
         if row < 0 || row >= board.numRows { continue }
         let column = tetromino.origin.column + block.column
         if column < 0 || column >= board.numColumns { continue }
         board.grid[row][column] = tetromino.type
      }
   }
   
   private func isValid(tetromino: Tetromino) -> Bool {
      for block in tetromino.blocks {
         let row = tetromino.origin.row + block.row
         if row < 0 || row >= board.numRows { return false }
         let column = tetromino.origin.column + block.column
         if column < 0 || column >= board.numColumns { return false }
         if board.grid[row][column] != nil { return false }
      }
      return true
   }
   
   
   private func getPoints(numCleared: Int) -> Int {
      switch numCleared {
         case 1:
            return 400
         case 2:
            return 1000
         case 3:
            return 3000
         case 4, 5, 6:
            return 12000
         default:
            return 0
      }
   }
}

