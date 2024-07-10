//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import XCTest
@testable import MovieQuiz // импортируем наше приложение для тестирования

final class ArrayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
            // Given
            let array = [1, 1, 2, 3, 5]
            
            // When
            let value = array[safe: 2]
            
            // Then
            XCTAssertNotNil(value)
            XCTAssertEqual(value, 2)
       }
       
       func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
           // Given
          let array = [1, 1, 2, 3, 5]
          
          // When
          let value = array[safe: 20]
          
          // Then
          XCTAssertNil(value)
       }

}
