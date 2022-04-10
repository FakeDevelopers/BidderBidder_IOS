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
        socialLoginButton1.roundCorners(cornerRadius: 50, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        socialLoginButton2.roundCorners(cornerRadius: 50, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        normalLoginButton.roundCorners(cornerRadius: 50, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
}



extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 30
    }
}
