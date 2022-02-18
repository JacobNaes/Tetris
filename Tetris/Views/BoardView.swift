//
//  BoardView.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import SwiftUI

struct BoardView: View {
   let tetromino: Tetromino?
   let board: [[Color]]
   let numColumns: Int
   let numRows: Int
   let geo: GeometryProxy
   let blockSize: CGFloat
   let xOffset: CGFloat
   let yOffset: CGFloat
   
   
   init(geoProxy: GeometryProxy, rows: Int, columns: Int, board: [[BlockType?]], tetromino: Tetromino?) {
      self.tetromino = tetromino
      self.board = BoardView.transformBoard(grid: board, tetromino: tetromino)
      self.numColumns = columns
      self.numRows = rows
      self.geo = geoProxy
      self.blockSize = min(geoProxy.size.width/CGFloat(columns), geoProxy.size.height/CGFloat(rows))
      self.xOffset = (geoProxy.size.width - blockSize*CGFloat(columns))/2
      self.yOffset = (geoProxy.size.height - blockSize*CGFloat(rows))/2
   }
   
   
   var body: some View {
      ForEach(0..<numColumns, id: \.self) { column in
         ForEach(0..<numRows, id: \.self) { row in
            Path { path in
               let x = xOffset + blockSize * CGFloat(column)
               let y = geo.size.height - yOffset - blockSize*CGFloat(row+1)
               let rect = CGRect(x: x, y: y, width: blockSize, height: blockSize)
               path.addRect(rect)
            }
            .fill(board[row][column])
         }
      }
   }
   
   private static func transformBoard(grid: [[BlockType?]], tetromino: Tetromino?) -> [[Color]] {
      var board = grid.map { $0.map(getColor(tetrominoType:)) }
      if let tetromino = tetromino {
         for block in tetromino.blocks {
            board[block.row + tetromino.origin.row][block.column + tetromino.origin.column] = getColor(tetrominoType: tetromino.type)
         }
      }
      return board.reversed()
   }
   
   private static func getColor(tetrominoType: BlockType?) -> Color {
      switch tetrominoType {
         case .i:
            return .blue
         case .t:
            return .green
         case .o:
            return .orange
         case .j:
            return .pink
         case .l:
            return .purple
         case .s:
            return .yellow
         case .z:
            return .red
         case .none:
            return.black
      }
   }
}

struct BoardView_Previews: PreviewProvider {
   static var previews: some View {
      GeometryReader { geo in
         BoardView(geoProxy: geo, rows: 23, columns: 10, board: [[]], tetromino: nil)
      }
   }
}
