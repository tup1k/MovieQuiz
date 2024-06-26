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
        case total
        case allCorrect
        case allTotal
        case bestGame
        case gamesCount
        case totalAccuracy
    }
    
    // Количество квизов
    var gamesCount: Int {
        get {
            userData.integer(forKey: Keys.gamesCount.rawValue) // чтение числа сыгранных квизов из памяти
        }
        
        set {
            userData.set(newValue, forKey: Keys.gamesCount.rawValue) // запись числа сыгранных квизов в память
        }
    }
    
    // Количество правильных ответов
    var allCorrect: Int {
        get {
            userData.integer(forKey: Keys.allCorrect.rawValue) // чтение числа правильных ответов из памяти
        }
        
        set {
            userData.set(newValue, forKey: Keys.allCorrect.rawValue) // запись числа правильных ответов в память
        }
    }
    
    // Количество вопросов
    var allTotal: Int {
        get {
            userData.integer(forKey: Keys.allTotal.rawValue) // чтение числа вопросов из памяти
        }
        
        set {
            userData.set(newValue, forKey: Keys.allTotal.rawValue) // запись числа вопросов в память
        }
    }
    
    // Параметры лучшего квиза за все время
    var bestGame: GameResult {
        get {
            let correctAnswQuestion = userData.integer(forKey: "correct")
            let totalQuestion = userData.integer(forKey: "total")
            let dateOfQuestion = userData.object(forKey: "date")
            let topGameResult = GameResult(correct: correctAnswQuestion, total: totalQuestion, date: dateOfQuestion as? Date ?? Date())
            
        return topGameResult
        }
        
        set {
            userData.set(newValue.correct, forKey: "correct")
            userData.set(newValue.total, forKey: "total")
            userData.set(newValue.date, forKey: "date")
            
        }
    }
    
    // Точность правильных ответов за все игры в процента (накопленный correct /10 * gamesCount)
    var totalAccuracy: Double {
        get {
            userData.double(forKey: Keys.totalAccuracy.rawValue)
            
            guard gamesCount != 0 else {
                return 0
            }
           return  (100 * Double(self.allCorrect)) / (10 * Double(self.gamesCount))
        }
        
        set {
            userData.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    // Метод подготовки данных для алерта
    func store(correct count: Int, total amount: Int) {
//        // Для обнуления данных
//        UserDefaults.standard.removeObject(forKey: "correct")
//        UserDefaults.standard.removeObject(forKey: "total")
//        UserDefaults.standard.removeObject(forKey: "gamesCount")
//        UserDefaults.standard.removeObject(forKey: "allCorrect")
//        UserDefaults.standard.removeObject(forKey: "allTotal")
       
       
        let lastBestResult = bestGame
        let newBestResult = GameResult(correct: count, total: amount, date: Date())
       
        if lastBestResult.answerCompare(newBestResult) {
            bestGame = lastBestResult
        } else {
            bestGame = newBestResult
        }
        
        self.allCorrect += count
        self.allTotal += amount
        self.gamesCount += 1
        print(bestGame.correct)
        print(bestGame.total)
        print(self.totalAccuracy)
        print(self.allCorrect)
        print(self.allTotal)
    }
}
