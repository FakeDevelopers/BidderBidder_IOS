//
//  UIView.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/08/05.
//

import UIKit

extension UIView {
    func addGesture(_ action: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }
}

extension UIView {
    func makeRounded(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func makeRoundedWithBorder(radius: CGFloat, color: CGColor) {
        makeRounded(radius: radius)
        layer.borderWidth = 1
        layer.borderColor = color
    }
}
