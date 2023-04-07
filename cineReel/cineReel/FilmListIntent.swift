//
//  FilmListViewModel.swift
//  cineReel
//
//  Created by Cezar_ on 04.04.23.
//

import Foundation
import Combine

class FilmListIntent {

    private let network: NetworkControllerType
    private let output: PassthroughSubject<Event, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1

    init(network:NetworkControllerType = NetworkController()) {
        self.network = network
    }

    func transform(input: AnyPublisher<State, Never>) -> AnyPublisher<Event, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .begining:
                self.getFilmList(page: 1)
            case .loadingFilmList(let page):
                self.getFilmList(page: currentPage)
            case .searchDidTap(let query, let page):
                self.getFilmSearchList(query: query, page: page)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    func filterFilms(_ films: [Film], with searchText: String) -> String {
        guard !searchText.isEmpty else {
            return ""
        }
        print(searchText)
        return searchText
    }

    private func getFilmSearchList(query: String, page: Int) {
        let url = URL(string:
                        "https://api.themoviedb.org/3/search/movie?api_key=815b63b537c380370911f6cb083031b0&query=\(query)&page=\(page)")!
        //        guard let url = URL(string: Tmdb.getPopularMoviesWithKey(api_key: "815b63b537c380370911f6cb083031b0", page: 1).rawValue) else {
//            return
//        }
        network.get(type: ListResponse.self, url: url).sink { [weak self] completion  in
            if case .failure(let error) = completion {
                self?.output.send(.fetchFilmsDidFail(error: error))
            }
        } receiveValue: { [weak self] films  in
            self?.output.send(.fetchFilmsDidSuccessful(films: films.results))
        }.store(in: &cancellables)

    }

    private func getFilmList(page: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=815b63b537c380370911f6cb083031b0&language=en-US&page=\(page)")!

        network.get(type: ListResponse.self, url: url).sink { [weak self] completion  in
            if case .failure(let error) = completion {
                self?.output.send(.fetchFilmsDidFail(error: error))
            }
        } receiveValue: { [weak self] films  in
            self?.output.send(.fetchFilmsDidSuccessful(films: films.results))
        }.store(in: &cancellables)

    }

    enum State {
        case begining
        case loadingFilmList(requestTupe: RequestType = .popularFilmList, page: Int = 1)
        case searchDidTap(query: String, page: Int)
    }

    enum Event {
        case fetchFilmsDidFail(error: Error)
        case fetchFilmsDidSuccessful(films: [Film])
        case filmSelected(filmId: Int)
    }

    enum RequestType {
        case popularFilmList
        case searchingList
    }
    
}
