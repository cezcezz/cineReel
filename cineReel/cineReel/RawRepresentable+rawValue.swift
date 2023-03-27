//
//  RawRepresentable+rawValue.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//

import Foundation

extension RawRepresentable where RawValue == String, Self: API {

    var url: URL {
        Self.baseUrl.appendingPathComponent(rawValue)
    }
}
