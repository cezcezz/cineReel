//
//  APIProtocols.swift
//  cineReel
//
//  Created by Cezar_ on 03.04.23.
//

import Foundation
import Combine

protocol Request {
    associatedtype Response: Decodable
    associatedtype ResponseParser: ResponseParserType where ResponseParser.Response == Response

    var baseUrl: String { get }
    var path: String { get }
    var method: String { get }

    var header: [String: String]? { get }
    var parser: ResponseParser? { get }
    var errorParser: ErrorParserType? { get }

    func parameter() -> [String: Any]?
}

protocol RequestConvertable: Request {
    func asURLRequest() throws -> URLRequest
}

protocol ResponseParserType {
    associatedtype Response
    func parse(data: Data) throws -> Response?
}

public typealias JSONDictionary = [String : Any]

protocol ErrorParserType {
    func parse(data: JSONDictionary) -> Error?
}


protocol RequestExecutor {
    func executeRequest<R>(request: R) -> AnyPublisher<R.Response, Error> where R: RequestConvertable
}
