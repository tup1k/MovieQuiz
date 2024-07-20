//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Олег Кор on 20.07.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {   
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func clearImageBorder()
    func showNetworkError(message: String)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func show(quiz step: QuizStepViewModel)
    func showRes(quiz result: AlertModel)
    func didReceiveNextQuestion(question: QuizQuestion?)
}
