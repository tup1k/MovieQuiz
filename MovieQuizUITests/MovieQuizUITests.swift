//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Олег Кор on 15.07.2024.
//

import Foundation
import XCTest
//@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
 
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        sleep(8)
        let firstPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        //let firstPoster = app.images["Poster1"] // Проверка несуществующего постера
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(8)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        //XCTAssertTrue(firstPoster.exists)
        //XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        //let firstPoster = app.images["Poster1"] // Проверка несуществующего постера
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(6)
        app.buttons["No"].tap()
        sleep(6)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        //XCTAssertTrue(firstPoster.exists)
        //XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "3/10")
    }
    
    func testAllertPresenter() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap() // Жмем 10 раз на кнопку НЕТ для прохождения квиза
            sleep(6)
        }
        
        let allertMessage = app.alerts["QuizAlert"] //Считываем какой алерт смотреть
        
        XCTAssertTrue(allertMessage.exists)
        XCTAssertTrue(allertMessage.label == "Этот раунд окончен!")
        XCTAssertTrue(allertMessage.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAllertPresenterClose() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(6)
        }
        let allertMessage = app.alerts["QuizAlert"] // Считываем какой алерт смотреть
        allertMessage.buttons.firstMatch.tap() // Жмем кнопку алерта
        sleep(8)
        
        let indexLabel = app.staticTexts["Index"] // Считываем какой лейбл смотреть
        
        XCTAssertFalse(allertMessage.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}




