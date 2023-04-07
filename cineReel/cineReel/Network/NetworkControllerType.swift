//
//  NetworkControllerProtocol.swift
//  cineReel
//
//  Created by Cezar_ on 05.04.23.
//

import Foundation
import Combine

protocol NetworkControllerType: AnyObject {

    func get<T>(type: T.Type,
                url: URL
    ) -> AnyPublisher<T, Error> where T: Decodable
}
