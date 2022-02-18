//
//  GeneticAlgorithm.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import Foundation

struct GeneticAlgorithm {
   let tetrominos: [Tetromino]
   var population: [Chromosome] = []
   var generation: Int = 1
   let populationSize: Int
   let numElites: Int
   let mutationRate: Double
   let poolSize: Int
   
   private let rows: Int
   private let columns: Int
   
   
   init(rows: Int, columns: Int, tetrominos: [Tetromino], popSize: Int, mRate: Double, numElites: Int) {
      self.rows = rows
      self.columns = columns
      self.tetrominos = tetrominos
      self.populationSize = popSize
      self.numElites = numElites
      self.mutationRate = mRate
      self.poolSize = populationSize / 2
   }
   
   
   mutating func initializePopulation() async {
      var initialGenomes = [Genome]()
      
      for _ in 0..<populationSize {
         let randomGenome = Genome()
         initialGenomes.append(randomGenome)
      }
      
      let tetrisGames = initialGenomes.map { genome in
         TetrisAI(gene: genome, rows: rows, columns: columns, tetrominos: tetrominos)
      }
      
      let results = await runTetrisGames(tetrisGames: tetrisGames)
      
      let population = results
         .map { Chromosome(genome: $0.genome, fitness: $0.gameScore, moveSequence: $0.moveSequences) }
         .sorted { $0.fitness > $1.fitness }
      
      self.population = population
   }
   
   
   
   mutating func nextGeneration() async {
      let currentGeneration = population
      let pool = createMatingPool(with: currentGeneration)
      let children = breed(pool)
      
      let tetrisGames = children.map { genome in
         TetrisAI(gene: genome, rows: rows, columns: columns, tetrominos: tetrominos)
      }
      
      let results = await runTetrisGames(tetrisGames: tetrisGames)
      
      let newPopulation = results
         .map { Chromosome(genome: $0.genome, fitness: $0.gameScore, moveSequence: $0.moveSequences)}
         .sorted(by: { $0.fitness > $1.fitness })
      
      
      self.population = newPopulation
      self.generation += 1
   }
   
   
   
   private func breed(_ pool: [Chromosome]) -> [Genome] {
      var children = [Genome]()
      for i in 0..<numElites {
         children.append(pool[i].genome)
      }
      
      while children.count < populationSize {
         let p1 = pool.randomElement()!
         let p2 = pool.randomElement()!
         let child = randomCross(p1: p1.genome, p2: p2.genome)
         children.append(child)
      }
      
      for i in children.indices {
         if shouldMutate(prob: mutationRate) {
            children[i] = mutate(children[i])
         }
      }
      
      return children
   }
   
   
   
   private func createMatingPool(with population: [Chromosome]) -> [Chromosome] {
      var pool = [Chromosome]()
      let sorted = population.sorted(by: { $0.fitness > $1.fitness })
      for i in 0..<poolSize {
         pool.append(sorted[i])
      }
      return pool
   }
   
   
   private func randomCross(p1: Genome, p2: Genome) -> Genome {
      let bumpiness = [p1.bumps, p2.bumps]
      let height = [p1.height, p2.height]
      let lines = [p1.lines, p2.lines]
      let holes = [p1.holes, p2.holes]
      let child = Genome(
         bumps: bumpiness.randomElement()!,
         holes: holes.randomElement()!,
         lines: lines.randomElement()!,
         height: height.randomElement()!
      )
      
      return child
   }
   
   
   private func mutate(_ genome: Genome) -> Genome {
      let bumpiness = genome.bumps + Double.random(in: -0.002...0.002)
      let holes = genome.holes + Double.random(in: -0.002...0.002)
      let lines = genome.lines + Double.random(in: -0.002...0.002)
      let height = genome.height + Double.random(in: -0.002...0.002)
      return Genome(bumps: bumpiness, holes: holes, lines: lines, height: height)
   }
   
   
   private func shouldMutate(prob: Double) -> Bool {
      let range = 0...Double.random(in: 0...1)
      if range.contains(1-prob) {
         return true
      } else {
         return false
      }
   }
   
   
   private func weightedSelect(from population: [Chromosome]) -> Chromosome {
      var selection: Chromosome?
      var sum = 0.0
      population.forEach { sum += Double($0.fitness) }
      var p = Double.random(in: 0...sum)
      for chromosome in population {
         p -= Double(chromosome.fitness)
         if p < 0 {
            selection = chromosome
            break
         }
      }
      
      return selection!
   }
   
   
   private func runTetrisGames(tetrisGames: [TetrisAI]) async -> [TetrisAI] {
      let games = await withTaskGroup(of: TetrisAI.self) { group -> [TetrisAI] in
         for game in tetrisGames {
            group.addTask(priority: .high) {
               game.runGame()
               return game
            }
         }
         
         var collected = [TetrisAI]()
         for await value in group {
            collected.append(value)
         }
         return collected
      }
      return games
   }
}
