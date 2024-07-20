//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Олег Кор on 21.06.2024.
//

import Foundation
import UIKit

/// Класс формирования и передачи данных в алерт
final class AlertPresenter: AlertPresenterProtocol {
   
    weak var delegate: AlertPresenterDelegate? // Делегат для алерта
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    // Метод формирования алерта которые передается в контроллер
    func newLogicShowRez(newQuiz result: AlertModel) {
        
        let alert = UIAlertController( title: result.title, message: result.message, preferredStyle: .alert) // Текст у высплывающего сообщения
        alert.view.accessibilityIdentifier = "QuizAlert"
        // Текст и методы у кнопки
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let _ = self else { return }
            result.callback()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
