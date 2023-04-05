////
////  WebAPIClient.swift
////  cineReel
////
////  Created by Cezar_ on 03.04.23.
////
//
//import Foundation
//import Combine
//
//class WebApiClient: RequestExecutor {
//
//    private var configuration: URLSessionConfiguration
//    private var session: URLSession
//
//    init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
//        configuration = URLSession.shared.configuration
//        session = URLSession(configuration: configuration)
//    }
//
//    func executeRequest<R>(request: R)  -> AnyPublisher<R.Response, Error> where R : RequestConvertable {
//
//            guard let requestt = try? request.asURLRequest()  else {
//                return  Fail(error: APIError.badRequest).eraseToAnyPublisher()
//            }
//
//            return session.dataTaskPublisher(for: requestt)
//
//                .tryMap({ [self] (data: Data, response: URLResponse) -> Data in
//
//                if let httpResponse = response as? HTTPURLResponse {
//                    if request.reponseValidRange.contains(httpResponse.statusCode) {
//                        return data
//                    }else {
//                        throw parseError(data: data, response: response, errorParser: request.errorParser)
//                    }
//                } else {
//                    throw APIError.invalidResponse()
//                }
//            })
//            .tryMap { returnData in
//
//                if let parser = request.parser {
//
//                    do {
//                        return try parser.parse(data: returnData)
//                    } catch {
//                        throw APIError.parseError(error)
//                    }
//
//                } else {
//                    do {
//                        return try JSONDecoder().decode(R.Response.self, from: returnData)
//                    } catch {
//                        throw APIError.parseError(error)
//                    }
//                }
//
//            }
//            .mapError({ error in
//                if let error = error as? APIError {
//                    return error
//                } else {
//                    return APIError.unknown
//                }
//            })
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//        }
//
//
//    private func parseError(data: Data, response: URLResponse, errorParser: ErrorParserType?) -> Error {
//
//        var errorToReturn: Error?
//
//        if let httpUrlResponse = response as? HTTPURLResponse {
//
//            if let errorParser = errorParser
//            {
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
//                    if let parsedError = errorParser.parse(data: json) {
//                        errorToReturn = parsedError
//                    }
//                }
//            }
//
//            switch httpUrlResponse.statusCode {
//
//            case 400:
//                errorToReturn = APIError.badRequest
//            case 401:
//                errorToReturn = APIError.unAuthorised
//            case 404:
//                errorToReturn = APIError.notFound
//            case 400...499:
//                break
//            case 500...599:
//                errorToReturn = APIError.serverError
//            default:
//                errorToReturn = APIError.unknown
//            }
//        }
//
//        return errorToReturn ?? APIError.invalidResponse
//    }
//}
