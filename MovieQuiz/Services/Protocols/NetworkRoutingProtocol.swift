//
//  NetworkRoutingProtocol.swift
//  MovieQuizTests
//
//  Created by Дмитрий Матвеев on 09.07.2024.
//

import UIKit

protocol NetworkRoutingProtocol {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
