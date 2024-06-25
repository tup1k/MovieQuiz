//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Олег Кор on 20.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
