import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var questionTitleLabel: UILabel! // Статичный тайтл ВОПРОС
    @IBOutlet private weak var indexLabel: UILabel! // Тайтл с номером вопроса из числа всех вопросов (1/10)
    @IBOutlet private weak var imageView: UIImageView! // Тайтл с картинкой
    @IBOutlet private weak var questionLabel: UILabel! // Тайтл с текстом вопроса квиза
    @IBOutlet private weak var yesButton: UIButton! // Дизайн кнопки ДА
    @IBOutlet private weak var noButton: UIButton! // Дизайн кнопки НЕТ
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! // Индикатор загрузки
    
    private var alertPresenter: AlertPresenterProtocol?  //  Всплывающее окно
    private var statisticService: StatisticServiceProtocol = StatisticService() // Статистика по всем квизам
    private var sp05CurrentQuestion: QuizQuestion? // Вопрос который видит пользователь
    private var presenter: MovieQuizPresenter!
    
    // Функция, созданная для описания шрифтов кодом
    private func setFontProperties() {
        // Загруженные шрифты удается подключить либо так, либо через левые схемы параметров
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    // Функция выключает/выключает кнопки на время загрузки нового вопроса
    private func buttonsOnOff(turn status: Bool) {
        yesButton.isEnabled = status
        noButton.isEnabled = status
    }
    
    // Функция параметров индикатора загрузки при его включении
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // показываем индикатор загрузки
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // Функция параметров индикатора загрузки при его выключении
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // показываем индикатор загрузки
        activityIndicator.stopAnimating() // включаем анимацию
    }
    
    // Функция прозрачности рамки вокруг картинки
    func clearImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // Метод вызова всплывающего окна при ошибке загрузки данных
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let errorModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else {return}
                self.presenter.resetGame()
                self.presenter.questionfactoryLoadData()
            }
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter?.newLogicShowRez(newQuiz: errorModel)
    }
    
    // Функция подсветки рамок для правильного/неправильного ответа
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20
        buttonsOnOff(turn: true)
        imageView.layer.borderColor =  isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        buttonsOnOff(turn: false)
    }
    
    // Метод вывода на экран приложения конвертированных данных
    func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
        buttonsOnOff(turn: true)
    }
    
    // Метод выводит на экран результаты квиза ну и обнуляет все результаты при нажатии на кнопку
    func showRes(quiz result: AlertModel) {
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter?.newLogicShowRez(newQuiz: result)
    }
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self) // создаем ссылку на viewcontroller для presenter
        setFontProperties() // Создаем формат шрифтов для текста/кнопок
    }
        
    // Экшн кнопки ДА - ссылка на presenter
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    // Экшн кнопки НЕТ - ссылка на presenter
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
}

  
