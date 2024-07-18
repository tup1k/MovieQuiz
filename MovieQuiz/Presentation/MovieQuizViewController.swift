import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var questionTitleLabel: UILabel! // Статичный тайтл ВОПРОС
    @IBOutlet private weak var indexLabel: UILabel! // Тайтл с номером вопроса из числа всех вопросов (1/10)
    @IBOutlet private weak var imageView: UIImageView! // Тайтл с картинкой
    @IBOutlet private weak var questionLabel: UILabel! // Тайтл с текстом вопроса квиза (в нашем случае грузится из моковских данных)
    @IBOutlet private weak var yesButton: UIButton! // Дизайн кнопки ДА
    @IBOutlet private weak var noButton: UIButton! // Дизайн кнопки НЕТ
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! // Индикатор загрузки
    
    
    private var questionFactory: QuestionFactoryProtocol? //  Фабрика вопросов
    private var alertPresenter: AlertPresenterProtocol?  //  Всплывающее окно
    private var statisticService: StatisticServiceProtocol = StatisticService() // Статистика по всем квизам
    private var correctAnswers: Int = 0 // Переменная число правильных ответов для вывода в конце
    private var sp05CurrentQuestion: QuizQuestion? // Вопрос который видит пользователь
    private let presenter = MovieQuizPresenter()
    
    // Функция выключает/выключает кнопки на время загрузки нового вопроса
    private func buttonsOnOff(turn status: Bool) {
        yesButton.isEnabled = status
        noButton.isEnabled = status
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    // Метод, сообщающий об ошибке загрузки данных с сервера
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // Функция параметров индикатора загрузки при его включении
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // показываем индикатор загрузки
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // Функция параметров индикатора загрузки при его выключении
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // показываем индикатор загрузки
        activityIndicator.stopAnimating() // включаем анимацию
    }
    
    // Метод вызова всплывающего окна при ошибке загрузки данных
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
       
        let errorModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else {return}
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                //self.questionFactory?.requestNextQuestion()
                self.questionFactory?.loadData()
            }
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter?.newLogicShowRez(newQuiz: errorModel)
    }
    
    // Метод обнуления параметров при запуске нового квиза
    private func newQuizData() {
        presenter.resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // Функция, созданная для описания шрифтов кодом
    private func setFontProperties() {
        // Загруженные шрифты удается подключить либо так, либо через левые схемы параметров
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    // Метод вывода на экран приложения конвертированных данных
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
        buttonsOnOff(turn: true)
    }
    
    // Метод выводит на экран результаты квиза ну и обнуляет все результаты при нажатии на кнопку
    private func showRes(quiz result: AlertModel) {
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter?.newLogicShowRez(newQuiz: result)
    }
    
    // Метод выполняет действия в случае если ответ верный/не верный
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20
        buttonsOnOff(turn: true)
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        buttonsOnOff(turn: false)
        
        if isCorrect {
            correctAnswers += 1
        }
        
        // Отложенный запуск метода показа следуюшего вопроса/окончания квиза через 1 с
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    // Метод либо показывает следующий вопрос, либо показывает экран результатов квиза
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\n Количество сыграных квизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy)) %" // Выводит общую статистику по всем квизам
            let viewModel = AlertModel( // Создает объект структуры финала квиза
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                callback: newQuizData )
            showRes(quiz: viewModel) // Запускаем метод вывода на экран заключительного экрана
            imageView.layer.borderColor = UIColor.clear.cgColor // Почему то в учебе не указано что цвет рамки надо отключать или я слепой
        } else { // 2
            presenter.switchToNextQuestion() // Перебираем следующий индекс-вопрос
            self.questionFactory?.requestNextQuestion()
            imageView.layer.borderColor = UIColor.clear.cgColor // Почему то в учебе не указано что цвет рамки надо отключать или я слепой
        }
    }
    
    // Экшн кнопки ДА
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.sp05CurrentQuestion = sp05CurrentQuestion
        presenter.yesButtonClicked()
    }
    
    // Экшн кнопки НЕТ
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.sp05CurrentQuestion = sp05CurrentQuestion
        presenter.noButtonClicked()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFontProperties() //  Формат шрифтов
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        
        presenter.viewController = self
    }
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        sp05CurrentQuestion = question
        let convertedCurrentQuestion = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: convertedCurrentQuestion)
        }
    }
}

  
