//
//  Genetics.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation

struct Chromosome {
   let genome: Genome
   var fitness: Int
   var moveSequence: [Move] = []
}


struct Genome {
   var bumps: Double = Double.random(in: -1...1)
   var holes: Double = Double.random(in: -1...1)
   var lines: Double = Double.random(in: -1...1)
   var height: Double = Double.random(in: -1...1)
}
