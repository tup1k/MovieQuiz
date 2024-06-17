//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Олег Кор on 16.06.2024.
//

import Foundation

// Структура вопроса в базе мок-овских данных
internal struct QuizQuestion {
    let image: String // Картинки в эссетах, ссылки в виде названий
    let text: String
    let correctAnswer: Bool
}
