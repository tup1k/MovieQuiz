//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Олег Кор on 23.06.2024.
//

import Foundation

/// Класс вывода статистики по каждой игре и общей статистики по играм
final class StatisticService: StatisticServiceProtocol {
    private let userData: UserDefaults = .standard // Вводим замену для упрощения
    
    // Вводим перечисления для исключения текстового ввода параметров UserDefaults
    private enum Keys: String {
        case gamesCount
        case allCorrect
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
    }
    
    // Параметр - число сыгранных игр
    var gamesCount: Int {
        get {
            userData.integer(forKey: Keys.gamesCount.rawValue) // чтение числа сыгранных квизов из памяти
        }
        
        set {
            userData.set(newValue, forKey: Keys.gamesCount.rawValue) // запись числа сыгранных квизов в память
        }
    }
    
    // Параметр - накопленное число правильных ответов за все игры
    var allCorrect: Int {
        get {
            userData.integer(forKey: Keys.allCorrect.rawValue) // чтение числа правильных ответов из памяти
        }
        
        set {
            userData.set(newValue, forKey: Keys.allCorrect.rawValue) // запись числа правильных ответов в память
        }
    }
    
    // Параметр который включает в себя данные одного квиза: число правильных ответов, число вопросов, дата игры
    var bestGame: GameResult {
        get {
            let correctAnswQuestion = userData.integer(forKey: Keys.bestGameCorrect.rawValue) // записали число правильных ответов
            let totalQuestion = userData.integer(forKey: Keys.bestGameTotal.rawValue) // записали число вопросов
            let dateOfQuestion = userData.object(forKey: Keys.bestGameDate.rawValue) // записали дату игры
            let topGameResult = GameResult(correct: correctAnswQuestion, total: totalQuestion, date: dateOfQuestion as? Date ?? Date()) // Собрали структуру
            
        return topGameResult
        }
        
        set {
            userData.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue) // считали число правильных ответов
            userData.set(newValue.total, forKey: Keys.bestGameTotal.rawValue) // считали число вопросов
            userData.set(newValue.date, forKey: Keys.bestGameDate.rawValue) // считали дату игры
        }
    }
    
    // Параметр точности правильных ответов за все игры в процентах (накопленный correct /10 * gamesCount)
    var totalAccuracy: Double {
        get {
            userData.double(forKey: Keys.totalAccuracy.rawValue) // записали в память параметр суммарной точности
            
            guard gamesCount != 0 else { // проверили что не делим на ноль
                return 0
            }
           return  (100 * Double(self.allCorrect)) / (10 * Double(self.gamesCount)) // посчитали точность !!! лучше число игр в дальнейшем заменить на число вопросов
        }
        
        set {
            userData.set(newValue, forKey: Keys.totalAccuracy.rawValue) // считали точность из памяти пользователя
        }
    }
    
    // Метод анализа данных - получает результаты игры из контроллера и передает их в алерт
    func store(correct count: Int, total amount: Int) {
//        // Код для обнуления данных - применяется только для тестов !!!!!!!
//        UserDefaults.standard.removeObject(forKey: "correct")
//        UserDefaults.standard.removeObject(forKey: "total")
//        UserDefaults.standard.removeObject(forKey: "gamesCount")
//        UserDefaults.standard.removeObject(forKey: "allCorrect")
       
        let lastBestResult = bestGame // Записали лучшую последнюю игру
        let newBestResult = GameResult(correct: count, total: amount, date: Date()) // записали из контроллера параметры новой игры
       
        // Сравнили новую и старую игру и обновили рекорд при необходимости - лучше впоследствии переделать под замыкание
        if lastBestResult.answerCompare(newBestResult) {
            bestGame = lastBestResult
        } else {
            bestGame = newBestResult
        }
        
        self.gamesCount += 1 // Накапливаем суммарное количество игр
        self.allCorrect += count // Накапливаем суммарно количество правильных ответов за все игры
        

    }
}
