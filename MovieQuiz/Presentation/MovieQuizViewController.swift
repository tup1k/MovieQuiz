import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet private weak var questionTitleLabel: UILabel! // Статичный тайтл ВОПРОС
    @IBOutlet private weak var indexLabel: UILabel! // Тайтл с номером вопроса из числа всех вопросов (1/10)
    @IBOutlet private weak var imageView: UIImageView! // Тайтл с картинкой
    @IBOutlet private weak var questionLabel: UILabel! // Тайтл с текстом вопроса квиза (в нашем случае грузится из моковских данных)
    @IBOutlet private weak var yesButton: UIButton! // Дизайн кнопки ДА
    @IBOutlet private weak var noButton: UIButton! // Дизайн кнопки НЕТ
    
    //Общая структура
    private struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    // Структура данных для вывода на экран
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    //Структура данных для вывода на экран после всех вопросов
    private struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    // Структура вопроса в базе мок-овских данных
    private struct QuizQuestion {
        let image: String // Картинки в эссетах, ссылки в виде названий
        let text: String
        let correctAnswer: Bool
    }

    // Массив данных для квиза
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    private var currentQuestionIndex = 0 // Переменная индекс вопроса
    private var correctAnswers = 0 // Переменная число правильных ответов для вывода в конце

    // Метод перевода данных из представления базы данных в представление приложения
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizQuestionConvert = QuizStepViewModel(
                                image: UIImage(named: model.image) ?? UIImage(),
                                question: model.text,
                                questionNumber: "\(currentQuestionIndex + 1) /\(questions.count)")
        return quizQuestionConvert
    }
    
    // Метод вывода на экран приложения конвертированных данных
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    // Метод выводит на экран результаты квиза ну и обнуляет все результаты при нажатии на кнопку
    private func showRes(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                let firstQuestion = self.questions[self.currentQuestionIndex]
                let viewModel = self.convert(model: firstQuestion)
                self.show(quiz: viewModel)
            }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Метод выполняет действия в случае если ответ верный/не верный
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // Отложенный запуск метода показа следуюшего вопроса/окончания квиза через 1 с
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    
    // Метод либо показывает следующий вопрос, либо показывает экран результатов квиза
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/\(questions.count)" // Выводит статистику по квизу
            let viewModel = QuizResultViewModel( // Создает объект структуры финала квиза
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
            showRes(quiz: viewModel) // Запускаем метод вывода на экран заключительного экрана
            imageView.layer.borderColor = UIColor.clear.cgColor // Почему то в учебе не указано что цвет рамки надо отключать или я слепой
        } else { // 2
            currentQuestionIndex += 1 // Перебираем следующий индекс-вопрос
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel) // Показываем данные следующего вопроса
            imageView.layer.borderColor = UIColor.clear.cgColor // Почему то в учебе не указано что цвет рамки надо отключать или я слепой
        }
    }
    
    // Экшн кнопки ДА
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let myAnswer = true
        showAnswerResult(isCorrect: myAnswer == currentQuestion.correctAnswer) //запускаем метод сравнения нашего ответа с правильным в обоих случаях
    }
    
    // Экшн кнопки НЕТ
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let myAnswer = false
        showAnswerResult(isCorrect: myAnswer == currentQuestion.correctAnswer) //запускаем метод сравнения нашего ответа с правильным в обоих случаях
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загруженные шрифты удается подключить либо так, либо через левые схемы параметров
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)

        // После launchScreen запускаем первый вопрос
        let currentQuestion = questions[currentQuestionIndex]
        let convertedCurrentQuestion = convert(model: currentQuestion)
        show(quiz: convertedCurrentQuestion)
    }
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
