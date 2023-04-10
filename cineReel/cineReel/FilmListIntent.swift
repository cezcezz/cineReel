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
    private let output: PassthroughSubject<FilmListEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1

    init(network:NetworkControllerType = NetworkController()) {
        self.network = network
    }

    func transform(input: AnyPublisher<FilmListState, Never>) -> AnyPublisher<FilmListEvent, Never> {
        input.sink { [unowned self] event in
            switch event.status {
            case .start:
                self.getFilmList(page: 1)
            case .loadingFilmList:
                self.getFilmList(page: event.page)
            case .scrolledDown:
                var mutatingEvent = event
                currentPage = currentPage + 1
                mutatingEvent.page = event.page + 1
                self.getFilmList(page: currentPage)
            case .fetchFilmsDidSuccessful(let films):
                var mutatingEvent = event
                mutatingEvent.films.append(contentsOf: films)
            case .fetchFilmsDidFail(error: _): break
            case .searching(let text):
                currentPage = 1
                self.getFilmSearchList(query: text, page: currentPage)
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
        network.get(type: ListResponse.self, url: url).sink { [weak self] completion  in
            if case .failure(let error) = completion {
                self?.output.send(.fetchFilmsDidFail(error))
            }
        } receiveValue: { [weak self] films  in

           self?.output.send(.fetchFilmsDidSuccessful(films.results))
        }.store(in: &cancellables)

    }

    private func getFilmList(page: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=815b63b537c380370911f6cb083031b0&language=en-US&page=\(page)")!

        network.get(type: ListResponse.self, url: url).sink { [weak self] completion  in
            if case .failure(let error) = completion {
                self?.output.send(.fetchFilmsDidFail(error))
            }
        } receiveValue: { [weak self] films  in
            self?.output.send(.fetchFilmsDidSuccessful(films.results))
        }.store(in: &cancellables)
    }

    
}

//extension FilmListIntent {
//    static func reducer(state: inout FilmListState, event: FilmListEvent) -> FilmListState {
//        switch state.status {
//        case .start:
//            switch event {
//            case .viewDidLoad:
//                state.status = .loadingFilmList
//            default:
//                return state
//            }
//        case .loadingFilmList:
//            switch event {
//            case .fetchFilmsDidFail(let error):
//                state.status = .fetchFilmsDidFail(error: error)
//            case .fetchFilmsDidSuccessful(let films):
//                return .init(films: films, page: state.page, status: .fetchFilmsDidSuccessful(films: films))
//            default:
//                return state
//            }
//        case .fetchFilmsDidSuccessful(let films):
//            var stateMutating = state
//            stateMutating.films.append(contentsOf: films)
//            return state
//        case .scrolledDown:
//            switch event {
//            case .fetchFilmsDidFail(let error):
//                return .init(films: [], page: state.page + 1, status: .fetchFilmsDidFail(error: error))
//            case .fetchFilmsDidSuccessful(let films):
//                return .init(films: films, page: state.page + 1, status: .fetchFilmsDidSuccessful(films: films))
//            default:
//                return state
//            }
//        case .fetchFilmsDidFail(_):
//            return state
//        case .searching(let text):
//            print("State--searching \t \(text)")
//            return state
//        }
//        return state
//    }
//}
