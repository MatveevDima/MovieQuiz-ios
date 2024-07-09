//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import UIKit

class StatisticService : StatisticServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
//    init() {
//        userDefaults.set(0, forKey: Keys.totalAccuracy.rawValue)
//        userDefaults.set(0, forKey: Keys.correct.rawValue)
//        userDefaults.set(0, forKey: Keys.total.rawValue)
//        userDefaults.set(0, forKey: Keys.gamesCount.rawValue)
//        userDefaults.set(0, forKey: Keys.bestGame.rawValue)
//    }
    
    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var correctCount: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalCount: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return .init(correct: 0, total: 0, date: Date())
                }
            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
    func store(correct count: Int, total amount: Int) {
        
        let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        if (gameRecord.isBetterThan(bestGame)) {
            bestGame = gameRecord
        }
        let oldGamesCount = Double(gamesCount)
        correctCount += count
        totalCount += amount
        gamesCount += 1
        totalAccuracy = Double(correctCount) / Double(totalCount) * Double(100)
    }
    
    
    private enum Keys: String {
        case correct, total, totalAccuracy, bestGame, gamesCount
    }
}
