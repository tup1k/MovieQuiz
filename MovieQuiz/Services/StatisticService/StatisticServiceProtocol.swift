//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Олег Кор on 23.06.2024.
//

import Foundation

/// Протокол для класса вывода статистики
protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // Количество квизов
    var bestGame: GameResult { get } // Результаты лучшего квиза
    var totalAccuracy: Double { get } // Общая точность
    
    func store(correct count: Int, total amount: Int)// correct count число правильных ответов, total amount  суммарное число вопросов
}
