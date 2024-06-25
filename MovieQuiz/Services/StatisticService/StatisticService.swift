//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Олег Кор on 23.06.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let userData: UserDefaults = .standard
    
    // Вводим перечисления для исключения текстового ввода параметров UserDefaults
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
    }
    
    // Количество квизов
    var gamesCount: Int {
        get {
            userData.integer(forKey: Keys.gamesCount.rawValue) // чтение числа сыгранных квизов из памяти
        }
        
        set {
            userData.setValue(newValue, forKey: Keys.gamesCount.rawValue) // запись числа сыгранных квизов в память
        }
    }
    
    // Количество правильных ответов
    var correct: Int {
        get {
            userData.integer(forKey: Keys.correct.rawValue) // чтение числа правильных ответов из памяти
        }
        
        set {
            userData.setValue(newValue, forKey: Keys.correct.rawValue) // запись числа правильных ответов в память
        }
    }
    
    // Количество вопросов
    var total: Int {
        get {
            userData.integer(forKey: Keys.total.rawValue) // чтение числа вопросов из памяти
        }
        
        set {
            userData.setValue(newValue, forKey: Keys.total.rawValue) // запись числа вопросов в память
        }
    }
    
    // Параметры лучшего квиза за все время
    var bestGame: GameResult {
        get {
            let correctAnswQuestion = UserDefaults.standard.integer(forKey: "correct")
            let totalQuestion = UserDefaults.standard.integer(forKey: "total")
            let dateOfQuestion = UserDefaults.standard.object(forKey: "date")
            let newGameResult = GameResult(correct: correctAnswQuestion, total: totalQuestion, date: dateOfQuestion as? Date ?? Date())
            
            return newGameResult
        }
        
        set {
            userData.setValue(newValue, forKey: "correct")
            userData.setValue(newValue, forKey: "total")
            userData.setValue(newValue, forKey: "date")
        }
    }
    
    // Точность правильных ответов за все игры в процента (накопленный correct /10 * gamesCount)
    var totalAccuracy: Double {
        guard gamesCount != 0 else {
            return 0
        }
        return  Double(100 * self.correct / self.total)
    }
    
    func store(correct count: Int, total amount: Int) {
        
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        
    }
}
