//
//  Board.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation

struct Board {
   var grid: [[BlockType?]]
   let numRows: Int
   let numColumns: Int
   
   
   init(numRows: Int = 23, numColumns: Int = 10) {
      self.grid = Array(repeating: Array(repeating: nil, count: numColumns), count: numRows)
      self.numRows = numRows
      self.numColumns = numColumns
   }
   
   
   func calculateFitness(for genome: Genome) -> Double {
      let holes = Double(holes)
      let lines = Double(lines)
      let aggregateHeight = Double(aggregateHeight)
      let bumpiness = Double(bumpiness)
      
      let score = (
         (lines * genome.lines) +
         (aggregateHeight * genome.height) +
         (bumpiness * genome.bumps) +
         (holes * genome.holes)
      )
      
      return score
   }
   
   
   func clearLines(rowsCleared: (Int) -> Void) -> [[BlockType?]] {
      var newGrid = grid
      var rowsToClear = [Int]()
      for row in newGrid.indices {
         var emptySpace = false
         for col in newGrid[row].indices {
            if newGrid[row][col] == nil {
               emptySpace = true
            }
         }
         if !emptySpace {
            rowsToClear.append(row)
         }
      }
      if rowsToClear.count > 0 {
         for row in rowsToClear {
            newGrid.remove(at: row)
            newGrid.insert(Array(repeating: nil, count: numColumns), at: 0)
         }
      }
      rowsCleared(rowsToClear.count)
      return newGrid
   }
   
   
   var lines: Int {
      var count = 0
      for r in grid.indices {
         if isLine(at: r) {
            count += 1
         }
      }
      return count
   }
   
   
   
   var aggregateHeight: Int {
      var sum = 0
      for c in 0..<numColumns {
         sum += columnHeight(at: c)
      }
      return sum
   }
   
   
   
   var holes: Int {
      var count = 0
      for c in 0..<numColumns {
         var block = false
         for r in 0..<numRows {
            if grid[r][c] != nil {
               block = true
            } else if grid[r][c] == nil && block {
               count += 1
            }
         }
      }
      return count
   }
   
   
   var bumpiness: Int {
      var bumps = 0
      for c in 0..<numColumns - 1 {
         bumps += abs(columnHeight(at: c) - columnHeight(at: c + 1))
      }
      return bumps
   }
   
   
   func columnHeight(at column: Int) -> Int {
      var r = 0
      while r < numRows && grid[r][column] == nil {
         r += 1
      }
      return numRows - r
   }
   
   
   
   func isLine(at row: Int) -> Bool {
      return grid[row].allSatisfy({ $0 != nil })
   }
   
   
   func isEmptyRow(at row: Int) -> Bool {
      return grid[row].allSatisfy({ $0 == nil })
   }
}
