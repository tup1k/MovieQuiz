//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Олег Кор on 17.07.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticServiceProtocol! // Статистика по всем квизам
    private var questionFactory: QuestionFactoryProtocol? //  Фабрика вопросов
    //private weak var viewController: MovieQuizViewController?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private var sp05CurrentQuestion: QuizQuestion? // Вопрос который видит пользователь
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // Метод, сообщающий об ошибке загрузки данных с сервера
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    // Метод проверяет последний вопрос в квизе или нет
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // Метод обнуляет параметры игры и запрашивает новый вопрос
    func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // Метод заново подгружает данные в случае ошибок сети
    func questionfactoryLoadData() {
        questionFactory?.loadData()
    }
    
    // Метод увеличение индекса вопроса
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
        didAnswer(isYes: true)
    }
    
    // Логика кнопки НЕТ
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // Универсальный метод логики кнопок
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = sp05CurrentQuestion else {
            return
        }
        let myAnswer = isYes
        self.proceedWithAnswer(isCorrect: myAnswer == currentQuestion.correctAnswer) //запускаем метод сравнения ответов
    }
    
    // Метод-счетчик правильных ответов
    func didAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    // Метод либо показывает следующий вопрос, либо показывает экран результатов квиза
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: self.correctAnswers, total: self.questionsAmount)
            let text = "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)\n Количество сыграных квизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy)) %" // Выводит общую статистику по всем квизам
            let viewModel = AlertModel( // Создает объект структуры финала квиза
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                callback: resetGame )
            viewController?.showRes(quiz: viewModel) // Запускаем метод вывода на экран заключительного экрана
            viewController?.clearImageBorder() // Отключаем цвет рамки для следующего вопроса
        } else { // 2
            self.switchToNextQuestion() // Перебираем следующий индекс-вопрос
            questionFactory?.requestNextQuestion() // Запрашиваем у фабрики вопросов новый вопрос
            viewController?.clearImageBorder() // Отключаем цвет рамки для следующего вопроса
        }
    }
    
    // Метод выполняет действия в случае если ответ верный/не верный
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrect: isCorrect) // Прибавляет счетчик правильных ответов в случае верного ответа
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect) // Подсвечивает рамку в цвет правильности ответа
        
        // Отложенный запуск метода показа следуюшего вопроса/окончания квиза через 1 с
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        sp05CurrentQuestion = question
        let convertedCurrentQuestion = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: convertedCurrentQuestion)
        }
    }
}
