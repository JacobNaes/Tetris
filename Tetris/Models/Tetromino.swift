//
//  Tetromino.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation

struct Tetromino {
   var origin: BlockLocation
   let type: BlockType
   var rotation: Int
   
   var blocks: [BlockLocation] {
      type.getBlocks(rotation: rotation)
   }
   
   func move(dx: Int, dy: Int) -> Tetromino {
      let newOrigin = BlockLocation(row: origin.row + dy, column: origin.column + dx)
      return Tetromino(origin: newOrigin, type: type, rotation: rotation)
   }
   
   
   func rotate() -> Tetromino {
      Tetromino(origin: origin, type: type, rotation: rotation + 1)
   }
   
   
   static func createTetrominoBag(size: Int = 20_000, numRows: Int, numColumns: Int) -> [Tetromino] {
      var bag = [Tetromino]()
      
      for _ in 0..<size {
         let type = BlockType.allCases.randomElement()!
         let origin = BlockLocation(row: 0, column: numColumns/2 - 1)
         bag.append(Tetromino(origin: origin, type: type, rotation: 0))
      }
      
      return bag
   }
}
