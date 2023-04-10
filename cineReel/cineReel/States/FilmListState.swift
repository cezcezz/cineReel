//
//  FilmListState.swift
//  cineReel
//
//  Created by Cezar_ on 07.04.23.
//

import Foundation

struct FilmListState {
    var films: [Film] = [Film]() {
        didSet {
            self.films = oldValue + films
        }
    }
    var page: Int = 1
    var status: FilmListStatus = .start
}

enum FilmListStatus {
    case start
    case loadingFilmList/*(/*requestTupe: RequestType = .popularFilmList, page: Int*)*/*/
    case fetchFilmsDidSuccessful(films: [Film])
    case scrolledDown
    case fetchFilmsDidFail(error: Error)
    case searching(text: String)
}

enum FilmListEvent {
    case viewDidLoad
    case fetchFilmsDidFail(Error)
    case fetchFilmsDidSuccessful([Film])
    case filmSelected(filmId: Int)
    case scrolledDown
    case searching(text: String)
}

enum RequestType {
    case popularFilmList
    case searchingList
}
