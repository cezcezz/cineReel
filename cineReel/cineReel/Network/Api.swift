//
//  Api.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//

import Foundation

protocol API {
    static var baseUrl: URL { get }
}

enum Imdb: RawRepresentable, API {

    init?(rawValue: String) {
        nil
    }
//"https://imdb-api.com/en/API/Top250Movies/k_qzmj28aw"
    static var baseUrl: URL = URL(string: "https://imdb-api.com/")!

    case getPopularMoviesWithKey(key: String)

    var rawValue: String {
        switch self {
        case .getPopularMoviesWithKey(let key):
            return "movie/popular/api_key=\(key)"
        }
    }

}

