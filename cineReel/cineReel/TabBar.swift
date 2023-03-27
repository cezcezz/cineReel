//
//  TabBar.swift
//  cineReel
//
//  Created by Cezar_ on 24.03.23.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
        tabBar.tintColor = .label
        setUpVCs()
    }

    func setUpVCs() {
        viewControllers = [
            getNavigationController(for: ViewController(), title: "Films", image: UIImage(systemName: "film.fill")!)
        ]
    }

    private func getNavigationController(for rootViewController: UIViewController,
                                                                title: String,
                                                                image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }

}
