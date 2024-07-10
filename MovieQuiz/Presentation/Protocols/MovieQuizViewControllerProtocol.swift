//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 10.07.2024.
//

import UIKit

protocol MovieQuizViewControllerProtocol: UIViewController {
    
    func show(quizStep: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func hideImageBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
