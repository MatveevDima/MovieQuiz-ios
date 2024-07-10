import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var index: UILabel!
    
    private var presenter: MovieQuizPresenter?
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.presenter = MovieQuizPresenter(viewController: self)
        self.presenter!.restartGame()
        
        showLoadingIndicator()
    }
    
    // MARK: - Action
    @IBAction private func yesButtonAction(_ sender: Any) {
        presenter!.yesButtonAction(sender)
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        presenter!.noButtonAction(sender)
    }
    
    // MARK: - Lifecycle
    func show(quizStep: QuizStepViewModel) {
        image.image = quizStep.image
        index.text = quizStep.questionNumber
        question.text = quizStep.question
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        image.layer.masksToBounds = true
        image.layer.borderWidth = 8
        image.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        image.layer.cornerRadius = 6
    }
    
    func hideImageBorder() {
        image.layer.masksToBounds = false
        image.layer.borderWidth = 0
        image.layer.cornerRadius = 6
    }
    
    // MARK: - LoadingIndicator
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
