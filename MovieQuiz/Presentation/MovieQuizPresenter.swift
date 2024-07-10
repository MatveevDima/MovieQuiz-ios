//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 10.07.2024.
//

import UIKit

final class MovieQuizPresenter : QuestionFactoryDelegate, AlertPresenterDelegate {
    
    weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    var correctAnswers = 0
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.questionFactory = QuestionFactory(
            moviesLoader: MoviesLoader(
                networkClient: NetworkClient()
            ),
            delegate: self
        )
        self.questionFactory?.loadData()
        self.statisticService = StatisticService()
        self.alertPresenter =  AlertPresenter(delegate: self)
    }
    
    func yesButtonAction(_ sender: Any) {
        didAnswer(isYes: true)
    }
    
    func noButtonAction(_ sender: Any) {
        didAnswer(isYes: false)
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory!.requestNextQuestion()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            showResults()
            
        } else {
            switchToNextQuestion()
            questionFactory!.requestNextQuestion()
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController!.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.viewController!.hideImageBorder()
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    private func showNetworkError(message: String) {
        
        viewController!.hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            restartGame()
        }
        
        alertPresenter?.showResults(alertModel: model, on: viewController!)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController!.show(quizStep: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController!.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    func showResults() {
        
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        let totalAccuracy = statisticService?.totalAccuracy ?? Double(correctAnswers) / Double(questionsAmount)
        let gamesCount = statisticService?.gamesCount ?? 1
        let bestGame = statisticService?.bestGame
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        alertPresenter?.showResults(alertModel: AlertModel(
            title: "Этот раунд окончен!",
            message: """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(gamesCount))
            Рекорд: \(bestGame?.correct ?? correctAnswers)/\(bestGame?.total ?? questionsAmount) (\(dateFormatter.string(from: bestGame?.date ?? Date())))
            Средняя точность: \(String(format: "%.2f", totalAccuracy))%
            """,
            buttonText: "Сыграть ещё раз"
        ) { [weak self] in
            self?.restartGame()
        }, on: viewController!)
    }
}
