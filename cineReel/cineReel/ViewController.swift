//
//  ViewController.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//
import UIKit

class ViewController: UIViewController {

    var tableView = UITableView()
    let rightImage: UIImageView = {
        var image = UIImageView()
        image.downloaded(from: "https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_UX128_CR0,12,128,176_AL_.jpg")
        return image
    }()

    var filmsList = [Film]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var filmViewModel = [FilmViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let  baseUrl: URL = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_qzmj28aw") else { return }

        genericRequest(url: baseUrl) { (films: Films) in
            self.filmsList.append(contentsOf: films.films)
        }

        configureTableView()
        addedImageOnBar()

    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 196
        tableView.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        tableView.pin(to: view)
    }

    func setTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    fileprivate func genericRequest<T:Decodable>(url: URL, completion: @escaping (T) -> ()){
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else { return }

            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print("JSON error", jsonErr)
            }
        }.resume()
    }

    private func addedImageOnBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Films"

        DispatchQueue.main.async {
            guard let UINavigationLargeTitleView = NSClassFromString("_UINavigationBarLargeTitleView") else {
                return
            }
            self.navigationController?.navigationBar.subviews.forEach { subview in
                if subview.isKind(of: UINavigationLargeTitleView.self) {
                    let viewFilm = self.rightImage
                    viewFilm.clipsToBounds = true
                    subview.addSubview(viewFilm)
                    viewFilm.translatesAutoresizingMaskIntoConstraints = false

                    NSLayoutConstraint.activate([
                        viewFilm.rightAnchor.constraint(equalTo: subview.rightAnchor, constant: -15),
                        viewFilm.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -15),
                        viewFilm.heightAnchor.constraint(equalToConstant: 36),
                        viewFilm.widthAnchor.constraint(equalTo: viewFilm.heightAnchor)
                    ])
                }
            }

        }
    }

}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filmsList.count)
        return filmsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell") as! FilmCell
        let film = filmsList[indexPath.row]
        cell.set(film: film)
        return cell
    }

}

