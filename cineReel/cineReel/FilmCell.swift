//
//  FilmCell.swift
//  cineReel
//
//  Created by Cezar_ on 27.03.23.
//

import UIKit

class FilmCell: UITableViewCell {

    //var filmViewModel: FilmViewModel

    var filmImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
    var filmTitleLabel = UILabel()
    var filmYearLabel = UILabel()
    var filmRatingLabel = UILabel()

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


        guard let url = URL(string: "\(Tmdb.imageBaseUrl)\(film.posterPath)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Error parsing image data")
                return
            }

            DispatchQueue.main.async {
                self.filmImageView.image = image
            }
        }
        task.resume()
        filmTitleLabel.text = film.title
    }

    func configureImage() {
        filmImageView.layer.cornerRadius = 8
        filmImageView.clipsToBounds = true
    }

    func configureTitle() {
        filmTitleLabel.numberOfLines = 0
        filmTitleLabel.adjustsFontSizeToFitWidth = true
    }

    func configureYearLabel() {

    }

    func configureRatingLabel() {

    }

    func setImageConstraints() {
        filmImageView.translatesAutoresizingMaskIntoConstraints = false

        filmImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        filmImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        filmImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65).isActive = true

        //filmImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    //    filmImageView.widthAnchor.constraint(equalTo: filmImageView.heightAnchor, multiplier: 60).isActive = true
    }

    func setTitleLabelConstrints() {
        filmTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        filmTitleLabel.topAnchor.constraint(equalTo: filmImageView.topAnchor).isActive = true
        filmTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16).isActive = true
        //filmTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        filmTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
}
