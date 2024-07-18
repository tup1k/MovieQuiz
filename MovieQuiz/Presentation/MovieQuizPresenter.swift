//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Олег Кор on 17.07.2024.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var sp05CurrentQuestion: QuizQuestion? // Вопрос который видит пользователь
    weak var viewController: MovieQuizViewController?
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // Метод перевода данных из представления базы данных в представление приложения
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizQuestionConvert = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return quizQuestionConvert
    }
    
    
    // Логика кнопки ДА
   func yesButtonClicked() {
        guard let currentQuestion = sp05CurrentQuestion else {
            return
        }
        let myAnswer = true
       viewController?.showAnswerResult(isCorrect: myAnswer == currentQuestion.correctAnswer) //запускаем метод сравнения нашего ответа с правильным в обоих случаях
    }
    
    // Логика кнопки НЕТ
    func noButtonClicked() {
        guard let currentQuestion = sp05CurrentQuestion else {
            return
        }
        let myAnswer = false
        viewController?.showAnswerResult(isCorrect: myAnswer == currentQuestion.correctAnswer) //запускаем метод сравнения нашего ответа с правильным в обоих случаях
    }
}
