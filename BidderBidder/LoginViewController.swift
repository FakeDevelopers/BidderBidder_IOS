//
//  LoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit
import UnderLineTextField

class LoginViewController : UIViewController {
    
    @IBOutlet weak var idTextField: UnderLineTextField!
    @IBOutlet weak var passwordTextField: UnderLineTextField!
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
        self.layer.backgroundColor = UIColor(rgb: 0x21CEFF).cgColor
        self.layer.borderColor = UIColor(rgb: 0x21CEFF).cgColor
        self.layer.cornerRadius = 3
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.borderWidth = 1
        self.layer.backgroundColor = UIColor(rgb: 0x21CEFF).cgColor
        self.layer.borderColor = UIColor(rgb: 0x21CEFF).cgColor
        self.layer.cornerRadius = 30
    }
    
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
