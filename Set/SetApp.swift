//
//  SetApp.swift
//  Set
//
//  Created by MyBook on 08.02.2022.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            let game = SetViewModelGame()
            SetGameView(game: game)
        }
    }
}
