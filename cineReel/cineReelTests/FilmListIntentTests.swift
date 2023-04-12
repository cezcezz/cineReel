//
//  FilmListIntentTests.swift
//  cineReelTests
//
//  Created by Cezar_ on 11.04.23.
//

import XCTest
import Combine
@testable import cineReel

class ViewControllerTests: XCTestCase {

    var sut: ViewController!
    var viewModel: FilmListIntent!
    var networkController: NetworkController!
    var input: PassthroughSubject<FilmListEvent, Never>!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = FilmListIntent()
        networkController = NetworkController
        sut = ViewController()
        sut.viewModel = viewModel
        sut.networkController = networkController
        sut.loadViewIfNeeded()
        input = PassthroughSubject<FilmListEvent, Never>()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        sut = nil
        viewModel = nil
        networkController = nil
        input = nil
        cancellables = nil
        super.tearDown()
    }

    func testSearchBar() {
        let expectedQuery = "Harry Potter"

        let searchExpectation = expectation(description: "Search expectation")
        var status: FilmListState.Status?
        sut.input.send(.viewDidLoad)
        sut.tableView.scrollToRow(at: IndexPath(row: sut.films.count - 1, section: 0), at: .bottom, animated: false)
        sut.searchBar.text = expectedQuery
        input.send(.searching(expectedQuery))
        viewModel.transform(input: input.eraseToAnyPublisher())
            .sink { filmListState in
                status = filmListState.status
                switch filmListState.status {
                case .loadingFilmList:
                    XCTAssert(true)
                case .fetchFilmsDidSuccessful(let newFilms):
                    XCTAssertTrue(!newFilms.isEmpty)
                    searchExpectation.fulfill()
                default:
                    XCTFail()
                }
            }
            .store(in: &cancellables)

        wait(for: [searchExpectation], timeout: 5.0)
        XCTAssertEqual(status, .fetchFilmsDidSuccessful(films: viewModel.filterFilms(viewModel.filmSearchList?.results ?? [], with: expectedQuery)))
    }
}
