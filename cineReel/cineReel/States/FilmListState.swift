//
//  FilmListState.swift
//  cineReel
//
//  Created by Cezar_ on 07.04.23.
//

import Foundation

struct FilmListState {
    var films: [Film] = [Film]() 
    var page: Int = 1
    var status: FilmListStatus = .start
}

enum FilmListStatus {
    case start
    case loadingFilmList
    case fetchFilmsDidSuccessful(films: [Film])
    case fetchFilmsDidFail(error: Error)
}

enum FilmListEvent {
    case viewDidLoad
    case fetchFilmsDidFail(Error)
    case filmSelected(filmId: Int)
    case scrolledDown
    case searching(text: String)
}

enum RequestType {
    case popularFilmList
    case searchingList
}
