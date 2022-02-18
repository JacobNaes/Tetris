//
//  Blocks.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation

struct BlockLocation {
    var row: Int
    var column: Int
}


enum BlockType: CaseIterable {
    case i, t, o, j, l, s, z
    
    func getBlocks(rotation: Int) -> [BlockLocation] {
        let allBlocks = getAllBlocks()
        var index = rotation % allBlocks.count
        if index < 0 {
            index += allBlocks.count
        }
        return allBlocks[index]
    }
    
    func getAllBlocks() -> [[BlockLocation]] {
        switch self {
            case .i:
                return [
                    [BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 2), BlockLocation(row: 0, column: 3)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 2, column: 0), BlockLocation(row: 3, column: 0)],
                ]
            case .o:
                return [[BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 0)]]
            case .t:
                return [
                    [BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 2)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1), BlockLocation(row: 2, column: 0)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 2), BlockLocation(row: 1, column: 1)],
                    [BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 2, column: 1), BlockLocation(row: 1, column: 0)]
                ]
                
            case .j:
                return [
                    [BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 2, column: 1), BlockLocation(row: 2, column: 0)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 2)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 0), BlockLocation(row: 2, column: 0)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 2), BlockLocation(row: 1, column: 2)]
                ]
                
            case .l:
                return [
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 2, column: 0), BlockLocation(row: 2, column: 1)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 2), BlockLocation(row: 1, column: 0)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 2, column: 1)],
                    [BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 2), BlockLocation(row: 0, column: 2)]
                ]
            case .s:
                return [
                    [BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 2), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1)],
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1), BlockLocation(row: 2, column: 1)]
                ]
            case .z:
                return [
                    [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 2)],
                    [BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 0), BlockLocation(row: 2, column: 0)]
                ]
        }
    }
}
