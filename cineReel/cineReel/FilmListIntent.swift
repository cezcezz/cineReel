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
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    init(network:NetworkControllerType = NetworkController()) {
        self.network = network
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .viewDidAppear:
                self.getFilmList(page: 1)
            case .listWillEnd(page: let page):
                self.getFilmList(page: page)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private func getFilmList(page: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=815b63b537c380370911f6cb083031b0&language=en-US&page=\(page)")!
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

    enum Input {
        case viewDidAppear
        case listWillEnd(page: Int)
    }

    enum Output {
        case fetchFilmsDidFail(error: Error)
        case fetchFilmsDidSuccessful(films: [Film])
    }
    
}
