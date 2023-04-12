//
//  FilmCellSnapshotTests.swift
//  cineReelTests
//
//  Created by Cezar_ on 11.04.23.
//

import Foundation
import XCTest
import SnapshotTesting
import Kingfisher
@testable import cineReel

class FilmCellSnapshotTests: XCTestCase {

    func test() {
        let sut = FilmCell()
        let filmModel = Film(adult: nil, backdropPath: nil, genreIDS: [1], id: nil, originalLanguage: nil, originalTitle: "Avatar: The Way of Water", overview: nil, popularity: nil, posterPath: "https://image.tmdb.org/t/p/w500//t6HIqrRAclMCA60NsSmeqe9RmNV.jpg", releaseDate: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil)
        sut.set(film: filmModel)

        //let url = URL(string: "https://image.tmdb.org/t/p/w500//t6HIqrRAclMCA60NsSmeqe9RmNV.jpg")!
        assertSnapshot(matching: sut, as: .image, record: true)

//        sut.filmImageView.kf.setImage(with: url) { result in
//            switch result {
//            case .success:
//                assertSnapshot(matching: sut, as: .image, record: true)
//            case .failure:
//                print("\(result)")
//            }
//        }
    }
}

