//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // When
        
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                XCTAssertEqual(movies.items.count, 2)
                // сравниваем данные с тем, что мы предполагали
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        
        waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true) // говорим, что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // When
        
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Unexpected success") // эта функция проваливает тест
            case .failure(let error):
                // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                XCTAssertNotNil(error)
                // сравниваем данные с тем, что мы предполагали
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    struct StubNetworkClient: NetworkRoutingProtocol {
        
        enum TestError: Error { // тестовая ошибка
            case test
        }
        
        let emulateError: Bool // этот параметр нужен, чтобы заглушка эмулировала либо ошибку сети, либо успешный ответ
        
        func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
            if emulateError {
                
                handler(.failure(TestError.test))
            } else {
                handler(.success(expectedResponse))
            }
        }
        
        private var expectedResponse: Data {
            """
            {
               "errorMessage" : "",
               "items" : [
                  {
                     "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                     "fullTitle" : "Prey (2022)",
                     "id" : "tt11866324",
                     "imDbRating" : "7.2",
                     "imDbRatingCount" : "93332",
                     "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                     "rank" : "1",
                     "rankUpDown" : "+23",
                     "title" : "Prey",
                     "year" : "2022"
                  },
                  {
                     "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                     "fullTitle" : "The Gray Man (2022)",
                     "id" : "tt1649418",
                     "imDbRating" : "6.5",
                     "imDbRatingCount" : "132890",
                     "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                     "rank" : "2",
                     "rankUpDown" : "-1",
                     "title" : "The Gray Man",
                     "year" : "2022"
                  }
                ]
              }
            """.data(using: .utf8) ?? Data()
        }
    }
}
