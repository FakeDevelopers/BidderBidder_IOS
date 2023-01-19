//
//  IdViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2023/01/02.
//

import UIKit
import TweeTextField

class IdViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var doubleCheckBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doubleCheckBtn.makeRoundedWithBorder(radius: doubleCheckBtn.frame.height / 4.5, color: UIColor.lightGrayColor)
        doubleCheckBtn.backgroundColor = .white
        
    }
    
    @IBAction func emailWhileEditing(_ sender: UITextField) {
        let email = sender.text
        if checkEmail(str: email!) == false {
            emailLabel.text = "이메일 형식이 다릅니다."
            emailLabel.textColor = .red
        } else {
            emailLabel.text = "이메일 형식이 맞습니다."
            emailLabel.textColor = .blue
        }
    }
    
    func checkEmail(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
    
}
