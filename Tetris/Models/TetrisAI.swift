//
//  TetrisAI.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation


class TetrisAI {
   private (set) var board: Board
   private (set) var tetromino: Tetromino?
   private (set) var gameScore: Int = 0
   private (set) var gameOver: Bool = false
   let genome: Genome
   var moveSequences: [Move]
   
   private var tetrominoPieces: [Tetromino]
   private let numRows: Int
   private let numColumns: Int
   
   
   init(gene: Genome, rows: Int, columns: Int, tetrominos: [Tetromino]) {
      tetrominoPieces = tetrominos
      numRows = rows
      numColumns = columns
      genome = gene
      board = Board(numRows: rows, numColumns: columns)
      moveSequences = []
      tetromino = tetrominoPieces.removeFirst()
   }
   
   
   func runGame()  {
      while !gameOver {
         makeNextMove()
      }
   }
   
   func makeNextMove() {
      guard let currentTetromino = tetromino else { return }
      let move = findBestMove(for: currentTetromino)
      moveSequences.append(move)
      executeBestMove(move: move)
      
      board.grid = board.clearLines { numberOfLines in
         gameScore += getPoints(numCleared: numberOfLines)
      }
   
      guard let nextTetromino = tetrominoPieces.first else {
         gameOver = true
         return
      }
      
      tetrominoPieces.removeFirst()
      
      if isValid(tetromino: nextTetromino) {
         tetromino = nextTetromino
      } else {
         gameOver = true
         tetromino = nil
      }
   }
   

   
   private func findBestMove(for currentTetromino: Tetromino) -> Move {
      let originalTetromino = currentTetromino
      var bestScore = Double(Int.min)
      var bestMove: Move?
      
      let testingTetromino = currentTetromino
      var rotated = testingTetromino
      let numRotations = originalTetromino.type.getAllBlocks().count
      
      for rotation in 0..<numRotations {
         let numRightMoves = numberRightMoves(for: rotated)
         let numLeftMoves = numberLeftMoves(for: rotated)
         
         for rightMoves in 1...numRightMoves {
            let move = Move(right: rightMoves, left: 0, rotations: rotation)
            let score = tempMoveScore(move: move, tetromino: testingTetromino)
            if score > bestScore {
               bestScore = score
               bestMove = move
            }
         }
         
         for leftMoves in 1...numLeftMoves {
            let move = Move(right: 0, left: leftMoves, rotations: rotation)
            let score = tempMoveScore(move: move, tetromino: testingTetromino)
            if score > bestScore {
               bestScore = score
               bestMove = move
            }
         }
         
         let move = Move(right: 0, left: 0, rotations: rotation)
         let score = tempMoveScore(move: move, tetromino: testingTetromino)
         if score > bestScore {
            bestScore = score
            bestMove = move
         }
         
         rotated = rotated.rotate()
      }
      
      guard let best = bestMove else { fatalError() }
      return best
   }
   
   
   private func executeBestMove(move: Move) {
      guard tetromino != nil else { return }
      
      for _ in 0..<move.rotations {
         let _ = rotate(tetromino: &tetromino!)
      }
      
      for _ in 0..<move.right {
         let _  = moveRight(tetromino: &tetromino!)
      }
      
      for _ in 0..<move.left {
         let _  = moveLeft(tetromino: &tetromino!)
      }
      
      self.drop(tetromino: &tetromino!)
      self.placeTetromino(tetromino: tetromino!)
   }
   
   
   
   private func tempMoveScore(move: Move, tetromino: Tetromino) -> Double {
      var testingTetromino = tetromino
      
      for _ in 0..<move.rotations {
         let _ = rotate(tetromino: &testingTetromino)
      }
      
      for _ in 0..<move.right {
         let _ = moveRight(tetromino: &testingTetromino)
      }
      
      for _ in 0..<move.left {
         let _ = moveLeft(tetromino: &testingTetromino)
      }
      
      self.drop(tetromino: &testingTetromino)
      
      
      let tempBoard = temporaryPlace(tetromino: testingTetromino)
      
      //return calculateMoveScore(for: tempBoard)
      return tempBoard.calculateFitness(for: self.genome)
   }
   
   
   
//   private func calculateMoveScore(for board: Board) -> Double {
//      let holes = Double(board.holes)
//      let lines = Double(board.lines)
//      let aggregateHeight = Double(board.aggregateHeight)
//      let bumpiness = Double(board.bumpiness)
//
//      let score = (
//         (lines * genome.lines) +
//         (aggregateHeight * genome.height) +
//         (bumpiness * genome.bumps) +
//         (holes * genome.holes)
//      )
//
//      return score
//   }
   
   private func move(tetromino: inout Tetromino, dx: Int, dy: Int) -> Bool {
      let newTetromino = tetromino.move(dx: dx, dy: dy)
      if isValid(tetromino: newTetromino) {
         tetromino = newTetromino
         return true
      }
      return false
   }
   
   private func moveLeft(tetromino: inout Tetromino) -> Bool {
      move(tetromino: &tetromino, dx: -1, dy: 0)
   }
   
   private func moveRight(tetromino: inout Tetromino) -> Bool {
      move(tetromino: &tetromino, dx: 1, dy: 0)
   }
   
   private func moveDown(tetromino: inout Tetromino) -> Bool {
      move(tetromino: &tetromino, dx: 0, dy: 1)
   }
   
   private func drop(tetromino: inout Tetromino) {
      while moveDown(tetromino: &tetromino) {}
   }
   
   private func rotate(tetromino: inout Tetromino) -> Bool {
      let newTetromino = tetromino.rotate()
      if isValid(tetromino: newTetromino) {
         tetromino = newTetromino
         return true
      } else {
         return false
      }
   }
   
   private func isValid(tetromino: Tetromino) -> Bool {
      for block in tetromino.blocks {
         let row = tetromino.origin.row + block.row
         if row < 0 || row >= numRows { return false }
         let column = tetromino.origin.column + block.column
         if column < 0 || column >= numColumns { return false }
         if board.grid[row][column] != nil { return false }
      }
      return true
   }
   
   
   private func placeTetromino(tetromino: Tetromino) {
      for block in tetromino.blocks {
         let row = tetromino.origin.row + block.row
         if row < 0 || row >= numRows { continue }
         let column = tetromino.origin.column + block.column
         if column < 0 || column >= numColumns { continue }
         board.grid[row][column] = tetromino.type
      }
   }
   
   
   private func temporaryPlace(tetromino: Tetromino) -> Board {
      var testingBoard = board
      
      for block in tetromino.blocks {
         let row = tetromino.origin.row + block.row
         if row < 0 || row >= numRows { continue }
         let column = tetromino.origin.column + block.column
         if column < 0 || column >= numColumns { continue }
         testingBoard.grid[row][column] = tetromino.type
      }
      
      return testingBoard
   }
   
   private func numberLeftMoves(for tetromino: Tetromino) -> Int {
      var offsetFromOrigin = 0
      for block in tetromino.blocks {
         if block.column < offsetFromOrigin {
            offsetFromOrigin = block.column
         }
      }
      let numMoves = tetromino.origin.column + offsetFromOrigin
      return numMoves
   }
   
   
   private func numberRightMoves(for tetromino: Tetromino) -> Int {
      var offsetFromOrigin = 0
      for block in tetromino.blocks {
         if block.column > offsetFromOrigin {
            offsetFromOrigin = block.column
         }
      }
      let furthestRight = tetromino.origin.column + offsetFromOrigin
      let numMoves = (numColumns - 1) - furthestRight
      return numMoves
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
