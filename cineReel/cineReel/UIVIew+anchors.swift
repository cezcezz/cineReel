//
//  UIVIew+Anchors.swift
//  cineReel
//
//  Created by Cezar_ on 27.03.23.
//

import UIKit

extension UIView {

    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
