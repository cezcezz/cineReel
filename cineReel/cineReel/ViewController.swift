//
//  ViewController.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//
import UIKit
import Combine

class ViewController: UIViewController {

    let viewModel = FilmListIntent()
    let networkController = NetworkController()
    var cancellable = Set<AnyCancellable>()
    var currentPage: Int = 1

    var films = [Film]() {
        didSet {
            tableView.reloadData()
        }
    }

    private let input: PassthroughSubject<FilmListIntent.State, Never> = .init()

    let tableView = UITableView()
    let searchBar = UISearchBar()
    let rightImage: UIImageView = {
        var image = UIImageView()
        image.downloaded(from: "https://w7.pngwing.com/pngs/675/184/png-transparent-ticket-cinema-film-computer-icons-cinema-ticket-miscellaneous-label-text.png")
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureTableView()
        addedImageOnBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.begining)
    }
    //MARK: - MVI WorkFlow

    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                case .fetchFilmsDidSuccessful(let films):
                    if currentPage == 1 {
                        self.films = films
                    } else {
                        self.films += films
                        print("films")
                    }
                case .filmSelected(let filmId):
                    print("filmSelected")
                case .fetchFilmsDidFail(let error):
                    print("!!!!!!!-!_!_!__!_!_!_!_-1_!\(error.localizedDescription)")
                }
            }.store(in: &cancellable)
    }

    //MARK: - UI

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
        print(films.count)
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell") as! FilmCell
        let film = films[indexPath.row]
        cell.set(film: film)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == films.count - 3 {
            self.currentPage = 1 + films.count/20
            input.send(.loadingFilmList(page: self.currentPage))
            }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let filteredFilms = viewModel.filterFilms(films, with: searchText)
//        navigationItem.title = filteredFilms
        input.send(.searchDidTap(query: searchText, page: currentPage))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        input.send(.begining)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        print("searchBarCancelButtonClicked")
        self.currentPage = 1

    }
}

