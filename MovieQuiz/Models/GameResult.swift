//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Олег Кор on 23.06.2024.
//

import Foundation

// Структура данных по результатам игры
struct GameResult {
    let correct: Int // количество правильных ответов квиза
    let total: Int // количество вопросов квиза
    let date: Date // дата завершения раунда
    
    func answerCompare(_ difGame: GameResult) -> Bool {
        correct > difGame.correct
    }
}
