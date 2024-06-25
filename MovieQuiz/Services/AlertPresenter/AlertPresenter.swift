//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Олег Кор on 21.06.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
   
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func newLogicShowRez(newQuiz result: AlertModel) {
       
        let alert = UIAlertController( title: result.title, message: result.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let _ = self else { return }
            result.callback()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
