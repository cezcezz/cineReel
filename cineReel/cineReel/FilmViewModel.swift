//
//  FilmViewModel.swift
//  cineReel
//
//  Created by Cezar_ on 27.03.23.
//

import Foundation
import UIKit

struct FilmViewModel {
    
    let id: String
    let title: String
    let image: UIImageView
    let imDbRating: Double
    let year: Int

    static func configure(with model: Film) -> FilmViewModel {

        var imageView: UIImageView = {
            var image = UIImageView()
            image.downloaded(from: model.image)
            return image
        }()

        return FilmViewModel(id: model.id,
                             title: model.title,
                             image: imageView,
                             imDbRating: Double(model.imDbRating) ?? 404,
                             year: Int(model.year) ?? 2033)
    }
}
