//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Олег Кор on 21.06.2024.
//

import Foundation

// Структура данных для выводе алерта по результатам игры
struct AlertModel {
    let title: String // заголовок алерта
    let message: String // сообщение в алерте - в будушем статистика
    let buttonText: String // текст кнопки
    var callback: () -> () // функция выполняемая после алерта
    
    init(title: String, message: String, buttonText: String, callback: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.callback = callback
    }
}
