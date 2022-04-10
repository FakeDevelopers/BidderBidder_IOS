//
//  LoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var socialLoginButton1: UIButton!
    
    @IBOutlet weak var socialLoginButton2: UIButton!
    
    @IBOutlet weak var normalLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
}


class CornerButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 30
    }

}

