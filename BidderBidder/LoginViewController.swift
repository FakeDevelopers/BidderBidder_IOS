//
//  LoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit
import TweeTextField
import SwiftUI
import FirebaseAuth

class LoginViewController : UIViewController {
    
    @IBOutlet weak var myPasswordTextField: TweeAttributedTextField!
    @IBOutlet weak var socialLoginButton1: UIButton!
    @IBOutlet weak var socialLoginButton2: UIButton!
    @IBOutlet weak var normalLoginButton: UIButton!
    @IBOutlet weak var testTextField: TweeActiveTextField!
    @IBOutlet weak var verificationNumberTextField: TweeActiveTextField!
    @IBOutlet weak var timerLabel: UILabel!
    
    var limitTime: Int = 180
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sendVerifyNumber(_ sender: Any) {
        timerLabel.isHidden = false
        getSetTime()
        print(testTextField.text!)
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82 \(testTextField.text!)", uiDelegate: nil) { (verificationID, error) in
                if let id = verificationID {
                    UserDefaults.standard.set("\(id)", forKey: "verificationID")
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
    }
    
    @IBAction func verificiationButton(_ sender: Any) {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID"), let verificationCode = verificationNumberTextField.text else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        logIn(credential: credential)
    }
    
    func logIn(credential: PhoneAuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                print("LogIn Failed...")
            } else {
                print("LogIn Success!!")
                print("\(authResult!)")
            }
            
        }
    }
    
    @objc func getSetTime() {
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    func secToTime(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timerLabel.text = String(minute) + ":" + "0"+String(second)
        } else {
            timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        }
        else if limitTime == 0 {
            timerLabel.isHidden = true
        }
    }
    
    // 이게 없으면 터집니다.
    @IBAction func passwordBeginEditing(_ sender: TweeAttributedTextField) {
    }
    
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
    // 이게 없으면 터집니다.
    @IBAction func passwordEndEditing(_ sender: TweeAttributedTextField) {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}


class CornerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.backgroundColor = UIColor.skyBlueColor
        self.layer.borderColor = UIColor.skyBlueColor
        self.layer.cornerRadius = 3
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.borderWidth = 1
        self.layer.backgroundColor = UIColor.skyBlueColor
        self.layer.borderColor = UIColor.skyBlueColor
        self.layer.cornerRadius = 25
    }
    
}

