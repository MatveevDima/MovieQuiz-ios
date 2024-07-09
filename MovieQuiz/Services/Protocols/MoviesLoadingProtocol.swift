//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import UIKit

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
