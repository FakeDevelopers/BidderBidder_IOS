//
//  EnterLoginViewController.swift
//  BidderBidder
//
//  Created by 김성현 on 2022/04/06.
//

import UIKit
import Alamofire

class EnterLoginViewController : UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    let urlLogin:String = "http://3.38.81.213:8080/user/login"
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginButton.isEnabled = false
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        idTextField.becomeFirstResponder()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let vaildEmailValidationResult = isValidEmail(idTextField.text!)
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        vcName?.modalPresentationStyle = .fullScreen
        vcName?.modalTransitionStyle = .crossDissolve
        
        if vaildEmailValidationResult == true {
            self.present(vcName!,animated: true,completion: nil)
            sendRestRequest(url: urlLogin, params: ["email":idTextField.text, "passwd":passwordTextField.text] as Dictionary) {
                response in
                switch response.result {
                    
                case .success:
                    print("통신 성공")
                    
                case .failure(let error):
                    print("통신 실패 : ",(String(describing: error.errorDescription)))
                    
                }
            }
            
            
        }
        
    }
    
}

extension EnterLoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isIdNull = idTextField.text == ""
        let isIdEmpty = idTextField.text == " "
        let isPasswordNull = passwordTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == " "
        loginButton.isEnabled = !isIdNull && !isPasswordNull && !isIdEmpty && !isPasswordEmpty
    }
}


func sendRestRequest(url: String, params: Parameters?, isPost: Bool = true, response: @escaping (AFDataResponse<Data?>) -> Void) -> Request {
    return AF.request(url, method: isPost ? .post : .get, parameters: params).response(completionHandler: response)
}



