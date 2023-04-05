//
//  NetworkController.swift
//  cineReel
//
//  Created by Cezar_ on 05.04.23.
//

import Foundation
import Combine

final class NetworkController: NetworkControllerType {

    func get<T: Decodable>(type: T.Type, url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: .init(url: url))
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map {
                $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }


}
