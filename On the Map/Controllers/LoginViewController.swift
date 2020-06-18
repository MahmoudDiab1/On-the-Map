//
//  LoginViewController.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
//    MARK:- outlets
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
//   MARK:- Variables
    var keyboardHight : CGFloat=0
 
//    MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       unlockScreen(true)
        self.subscribeToKeyboardNotifications()
    }
//    MARK:- Actions
//    Login
    @IBAction func loginButtonPressed(_ sender: Any) {
        unlockScreen(false)
        guard let email = emailTextField.text , let password = passwordTextField.text   else { return }
        UserClient.authenticate(userName: email, password: password, completion: handleLogin(_:))
    }
  
//    SignUp
        
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!, options: [:], completionHandler: nil)
    }
    
    
    
//    MARK:- Helpers and Functions
    //    setup screen in different states (Active inactive)
        func unlockScreen(_ isEnabled:Bool) {
            emailTextField.isEnabled =  isEnabled
            passwordTextField.isEnabled = isEnabled
            loginButton.isEnabled = isEnabled
            signUpButton.isEnabled = isEnabled
            if isEnabled {
                activityIndicator.isHidden = isEnabled
                activityIndicator.stopAnimating()
              
            } else {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = isEnabled
            }
        }
    
    func handleLogin(_ result:Result<Auth?, Error>) {
        
        switch result {
        case .success(let dataResponse):
            guard let dataResponse = dataResponse else {return}
            Account.account.registered = dataResponse.account.registered
            Account.account.key = dataResponse.account.key
            DispatchQueue.main.async {
                let mainTabBar = self.storyboard!.instantiateViewController(identifier: "mainTabBar") as! mainTabBar
                mainTabBar.modalPresentationStyle = .fullScreen
                self.present(mainTabBar, animated: true, completion: nil)
            }
            
            
        case .failed(let error):
            if let error = error as NSError? {
                if error.code == 4865 {
                    DispatchQueue.main.async {
                        self.unlockScreen(true)
                        self.alertMessage(title: "Login failed", message:  "The username or password are incorrect.")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.unlockScreen(true)
                        self.alertMessage(title: "Network failure", message:"An error ocurred with the network connection.")
                    }
                }
            }
        }
    }
      


//   Error Message alert tool
    func alertMessage(title:String,message:String?) {
        errorMsgLabel.text = title
        let alertVC = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    //    MARK:- keyboard handeling
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)) ,
                                               name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)) ,                                                name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyBoardWillShow (_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyBoardWillHide (_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
        
    }
    
    
    // MARK:-    TextField delegat functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
