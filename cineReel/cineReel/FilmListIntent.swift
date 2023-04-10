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
    private let output: PassthroughSubject<FilmListState, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var isSearching: Bool = false
    private var searchingText: String?

    init(network:NetworkControllerType = NetworkController()) {
        self.network = network
    }

    func transform(input: AnyPublisher<FilmListEvent, Never>) -> AnyPublisher<FilmListState, Never> {
        input.sink { [unowned self] input in
            switch input {
            case .viewDidLoad:
                self.getFilmList(page: 1)
            case .fetchFilmsDidFail(let error):
                output.send(.init(status: .fetchFilmsDidFail(error: error)))
            case .filmSelected(let filmId): break
            case .scrolledDown:
                self.currentPage = currentPage + 1
                getFilmSearchList(page: currentPage)
                output.send(.init(page: currentPage, status: .loadingFilmList))
            case .searching(let text):
                if text == "" {
                    searchingText = nil
                } else {
                    searchingText = text
                }
                currentPage = 1
                getFilmSearchList(query: searchingText, page: currentPage)
                output.send(.init(page: currentPage, status: .loadingFilmList))
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

    func getPage() -> Int {
        return currentPage
    }

    private func getFilmSearchList(query: String? = nil, page: Int) {

        guard let query = searchingText else {
            getFilmList(page: page)
            return
        }

        let url = URL(string:
                        "https://api.themoviedb.org/3/search/movie?api_key=815b63b537c380370911f6cb083031b0&query=\(query)&page=\(page)")!
        network.get(type: ListResponse.self, url: url).sink { [weak self] completion  in
            if case .failure(let error) = completion {
                self?.output.send(.init(status: .fetchFilmsDidFail(error: error)))
            }
        } receiveValue: { [weak self] films  in
            self?.output.send(.init(page: page, status: .fetchFilmsDidSuccessful(films: films.results)))
        }.store(in: &cancellables)
    }

    private func getFilmList(page: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=815b63b537c380370911f6cb083031b0&language=en-US&page=\(page)")!

        network.get(type: ListResponse.self, url: url).sink { [weak self] completion  in
            if case .failure(let error) = completion {
                self?.output.send(.init(status: .fetchFilmsDidFail(error: error)))
                //(.fetchFilmsDidFail(error))
            }
        } receiveValue: { [weak self] films  in
            self?.output.send(.init(page: page, status: .fetchFilmsDidSuccessful(films: films.results)))
            //(.fetchFilmsDidSuccessful(films.results))
        }.store(in: &cancellables)
    }
}
