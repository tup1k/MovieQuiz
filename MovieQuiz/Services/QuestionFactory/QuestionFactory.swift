//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Олег Кор on 16.06.2024.
//

import Foundation

// класс создания фабрики вопросов
final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    //    /// Массив данных для квиза
    //    private let questions: [QuizQuestion] = [
    //            QuizQuestion(
    //                image: "The Godfather",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: true),
    //            QuizQuestion(
    //                image: "The Dark Knight",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: true),
    //            QuizQuestion(
    //                image: "Kill Bill",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: true),
    //            QuizQuestion(
    //                image: "The Avengers",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: true),
    //            QuizQuestion(
    //                image: "Deadpool",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: true),
    //            QuizQuestion(
    //                image: "The Green Knight",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: true),
    //            QuizQuestion(
    //                image: "Old",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: false),
    //            QuizQuestion(
    //                image: "The Ice Age Adventures of Buck Wild",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: false),
    //            QuizQuestion(
    //                image: "Tesla",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: false),
    //            QuizQuestion(
    //                image: "Vivarium",
    //                text: "Рейтинг этого фильма больше чем 6?",
    //                correctAnswer: false)
    //        ]
    //
    
    private weak var delegate: QuestionFactoryDelegate? // Делегат фабрики вопросов
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // Метод рандомного выбора индексов и запроса из массива вопросов по нему
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            let randomRating = Float.random(in: 5...9)
            guard let randomRatingForQuestion = Float(String(format: "%.1f", randomRating)) else { return }
            
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем \(randomRatingForQuestion)?"
            let correctAnswer = rating > randomRatingForQuestion
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
