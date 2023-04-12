//
//  FilmCell.swift
//  cineReel
//
//  Created by Cezar_ on 27.03.23.
//

import UIKit
import Kingfisher

class FilmCell: UITableViewCell {

    //var filmViewModel: FilmViewModel

    var filmImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
    var filmTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(filmImageView)
        addSubview(filmTitleLabel)
        filmImageView.contentMode = .scaleAspectFit
        configureImage()
        configureTitle()
        setImageConstraints()
        setTitleLabelConstrints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(film: Film) {
        guard let path = film.posterPath else { return }
        guard let url = URL(string: "\(Tmdb.imageBaseUrl)\(path)") else { return }

        self.filmImageView.kf.indicatorType = .activity
        self.filmImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "heart.fill"), options: [.transition(.fade(0.666))]) { [weak self] result in
            switch result {
            case .success:
                self?.filmTitleLabel.text = film.title
            case .failure:
                // Set the title label even if the image fails to load
                self?.filmTitleLabel.text = film.title
            }
        }
    }


//    func set(film: Film) {
//        guard let path = film.posterPath else { return }
//        guard let url = URL(string: "\(Tmdb.imageBaseUrl)\(path)") else { return }
//        self.filmImageView.kf.indicatorType = .activity
//        self.filmImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "heart.fill"), options: [.transition(.fade(0.666))])
//        self.filmTitleLabel.text = film.title
//    }

    func configureImage() {
        filmImageView.layer.cornerRadius = 8
        filmImageView.clipsToBounds = true
    }

    func configureTitle() {
        filmTitleLabel.numberOfLines = 0
        filmTitleLabel.adjustsFontSizeToFitWidth = true
    }

    func setImageConstraints() {
        filmImageView.translatesAutoresizingMaskIntoConstraints = false

        filmImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        filmImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        filmImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        filmImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5625).isActive = true

    }

    func setTitleLabelConstrints() {
        filmTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        filmTitleLabel.topAnchor.constraint(equalTo: filmImageView.topAnchor).isActive = true
        filmTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16).isActive = true
        filmTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
}
