//
//  Api.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//

import Foundation

protocol ApiEndpoints {
    static var baseUrl: URL { get }
    static var imageBaseUrl: URL { get }
}

enum Tmdb: RawRepresentable, ApiEndpoints {

    init?(rawValue: String) {
        nil
    }
    
    static var baseUrl: URL = URL(string: "https://api.themoviedb.org/3/movie")!
    static var imageBaseUrl: URL = URL(string: "https://image.tmdb.org/t/p/w500/")!

    case getPopularMoviesWithKey(api_key: String, page: Int)
    case getFilmPoster(posterPath: String)

    var rawValue: String {
        switch self {
        case .getPopularMoviesWithKey(let key, let page):
            return "popular?api_key=\(key)&page=\(page)"
        case .getFilmPoster(let posterPath):
            return "\(posterPath)"
        }
    }

}

