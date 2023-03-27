//
//  FilmModel.swift
//  cineReel
//
//  Created by Cezar_ on 27.03.23.
//

import Foundation

struct Film: Decodable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
    let imDbRatingCount: String
}

struct Films: Decodable {
    let films: [Film]
    let errorMessage: String

    enum CodingKeys: String, CodingKey {
        case films = "items"
        case errorMessage
    }
}
