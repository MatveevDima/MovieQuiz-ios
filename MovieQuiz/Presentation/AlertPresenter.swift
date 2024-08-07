//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 08.07.2024.
//

import UIKit

class AlertPresenter : AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func showResults(alertModel: AlertModel?, on viewController: UIViewController) {
        
        guard let alertModel = alertModel else { return }
        
        let alert = UIAlertController(
                title: alertModel.title,
                message: alertModel.message,
                preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "Game results"
            
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in

            alertModel.completion()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
