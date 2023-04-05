//
//  ApiCaller.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//

import Foundation

enum APIError: Error {
    case decode
    case invalidResponse
    case badRequest
    case parseError
    case unAuthorised
    case invalidURL
    case notFound
    case serverError
    case unauthorized
    case unexpectedStatusCode
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}

enum ParseError: Error, LocalizedError {
    case parserError(reason: String)

    var errorDescription: String? {
        switch self {
        case .parserError(let reason):
            return reason
        }
    }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

