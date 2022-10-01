//
//  UIView.swift
//  BidderBidder
//
//  Created by 김한빈 on 2022/09/06.
//

import UIKit

extension UIView {
    func addGesture(_ action: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }
}
