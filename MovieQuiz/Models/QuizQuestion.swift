//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Олег Кор on 16.06.2024.
//

import Foundation

// Структура вопросов в базе мок-овских данных
struct QuizQuestion {
    let image: Data // Картинки в эссетах, ссылки в виде названий
    let text: String
    let correctAnswer: Bool
}
