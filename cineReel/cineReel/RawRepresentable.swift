//
//  RawRepresentable.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//

import Foundation

public protocol RawRepresentable {
    associatedtype RawValue

    init?(rawValue: Self.RawValue)

    var rawValue: Self.RawValue { get }
}
