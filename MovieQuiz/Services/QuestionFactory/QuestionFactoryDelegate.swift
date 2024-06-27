//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Олег Кор on 20.06.2024.
//

import Foundation

// Делегат для создания фабрики вопросов
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
