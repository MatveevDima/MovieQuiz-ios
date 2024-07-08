//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий Матвеев on 08.07.2024.
//

import Foundation

struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> (Void)
}
