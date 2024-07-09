//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import Foundation

struct GameRecord : Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        return correct > another.correct
    }
}
