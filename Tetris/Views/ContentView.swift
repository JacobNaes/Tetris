//
//  ContentView.swift
//  Tetris
//
//  Created by Jacob Naes on 2/18/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TetrisView()
          .frame(minWidth: 1000, idealWidth: 1200, minHeight: 1000, idealHeight: 1200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
