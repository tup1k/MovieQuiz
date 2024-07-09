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
    func didLoadDataFromServer() // Сообщаем о загрузке данных с сервера
    func didFailToLoadData(with error: Error) // Сообщаем об ошибке загрузки данных с сервера
}
