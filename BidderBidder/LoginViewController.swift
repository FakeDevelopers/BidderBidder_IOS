//
//  LoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import FirebaseAuth
import SwiftUI
import TweeTextField
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var myPasswordTextField: TweeAttributedTextField!
    @IBOutlet var socialLoginButton1: UIButton!
    @IBOutlet var socialLoginButton2: UIButton!
    @IBOutlet var normalLoginButton: UIButton!
    @IBOutlet var testTextField: TweeActiveTextField!
    @IBOutlet var verificationNumberTextField: TweeActiveTextField!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var certificationButton: UIButton!

    var limitTime: Int = 180

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sendVerifyNumber(_: Any) {
        timerLabel.isHidden = false
        getSetTime()
        print(testTextField.text!)
        Auth.auth().useAppLanguage()
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82 \(testTextField.text!)", uiDelegate: nil) { verificationID, error in
                if let id = verificationID {
                    UserDefaults.standard.set("\(id)", forKey: "verificationID")
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        certificationButton.setTitle("재전송", for: .normal)
    }

    @IBAction func verificiationButton(_: Any) {
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
                self.alertVerify()
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
            timerLabel.text = String(minute) + ":" + "0" + String(second)
        } else {
            timerLabel.text = String(minute) + ":" + String(second)
        }

        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        } else {
            certificationButton.setTitle("인증", for: .normal)
            timerLabel.isHidden = true
        }
    }

    func alertVerify() {
        let alert = UIAlertController(title: "", message: "인증 실패했습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func passwordBeginEditing(_: TweeAttributedTextField) {
        // 이게 없으면 터집니다.
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

    @IBAction func passwordEndEditing(_: TweeAttributedTextField) {
        // 이게 없으면 터집니다.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

class CornerButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderWidth = 1
        layer.backgroundColor = UIColor.skyBlueColor
        layer.borderColor = UIColor.skyBlueColor
        layer.cornerRadius = 3
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layer.borderWidth = 1
        layer.backgroundColor = UIColor.skyBlueColor
        layer.borderColor = UIColor.skyBlueColor
        layer.cornerRadius = 25
    }
}
