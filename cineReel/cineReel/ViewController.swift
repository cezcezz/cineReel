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
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    var currentPage: Int = 1

    var films = [Film]() {
        didSet {
            tableView.reloadData()
        }
    }

    var input: PassthroughSubject<FilmListEvent, Never> = .init()

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
        input.send(.viewDidLoad)
    //    input.send()
    }
    //MARK: - MVI WorkFlow

    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] status in
                switch status.status {
                case .start:
                    films = status.films
                case .loadingFilmList: break
                case .fetchFilmsDidSuccessful(let newFilms):
                    if viewModel.getPage() > 1 {
                        self.films.append(contentsOf: newFilms)
                    } else {
                        self.films = newFilms
                    }
                case .fetchFilmsDidFail(let error):
                    let alert = UIAlertController(title: "error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
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

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
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
            input.send(.scrolledDown)
            }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.searching(text: searchText))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        print("searchBarCancelButtonClicked")
        self.currentPage = 1

    }
}

