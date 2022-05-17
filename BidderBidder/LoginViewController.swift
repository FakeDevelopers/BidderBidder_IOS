//
//  LoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit
import TweeTextField
import SwiftUI

class LoginViewController : UIViewController {
    
    @IBOutlet weak var myPasswordTextField: TweeAttributedTextField!
    @IBOutlet weak var socialLoginButton1: UIButton!
    @IBOutlet weak var socialLoginButton2: UIButton!
    @IBOutlet weak var normalLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 비밀번호 글자 입력이 시작될 때 <임시>
    // @IBAction func passwordBeginEditing(_ sender: TweeAttributedTextField) {
    // }
    
    // 비밀번호 글자가 입력중 일 때 <임시>
    @IBAction func passwordWhileEditing(_ sender: TweeAttributedTextField) {
        if let userInput = sender.text {
            if userInput.count == 0 {
                sender.hideInfo(animated: true)
            } else if userInput.count < 3 {
                sender.infoTextColor = .red
                sender.activeLineColor = .red
                sender.showInfo("3글자 이상 입력하세요!", animated: true)
            } else {
                sender.infoTextColor = .green
                sender.activeLineColor = .blue
                sender.showInfo("잘 하셨습니다!", animated: true)
            }
        }
    }
    // 비밀번호 글자가 입력이 끝날때 <임시>
    // @IBAction func passwordEndEditing(_ sender: TweeAttributedTextField) {
    // }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
}


class CornerButton: UIButton {
    
    let skyBlueColor = UIColor(rgb: 0x21CEFF)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.backgroundColor = skyBlueColor.cgColor
        self.layer.borderColor = skyBlueColor.cgColor
        self.layer.cornerRadius = 3
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.borderWidth = 1
        self.layer.backgroundColor = skyBlueColor.cgColor
        self.layer.borderColor = skyBlueColor.cgColor
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
