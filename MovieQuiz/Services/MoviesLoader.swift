//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import UIKit

struct MoviesLoader: MoviesLoadingProtocol {
    
    init(networkClient: NetworkRoutingProtocol) {
        self.networkClient = networkClient
    }
    
    // MARK: - NetworkClient
    private let networkClient : NetworkRoutingProtocol
        
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
                case .success(let data):
                    do {
                        let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                        handler(.success(mostPopularMovies))
                    } catch {
                        handler(.failure(error))
                    }
                    
                case .failure(let error):
                handler(.failure(error))
                
            }
        }
    }
}
