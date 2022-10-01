//
//  LoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var socialLoginButton1: UIButton!

    @IBOutlet var socialLoginButton2: UIButton!

    @IBOutlet var normalLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        [socialLoginButton1, socialLoginButton2, normalLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.layer.cornerRadius = 30
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
}
