//
//  LoginViewController.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        unlockScreen(true)
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        unlockScreen(false)
        guard let email = emailTextField.text , let password = passwordTextField.text   else { return }
        
        UserClient.authenticate(userName:email, password:password , completion: handleLogin(_:))
    }
    
    
    
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
    
    
    func alertMessage(title:String,message:String?) {
        errorMsgLabel.text = title
        let alertVC = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func handleLogin(_ result:Result<Auth?, Error>) {
        
        switch result {
        case .success(let dataResponse):
            DispatchQueue.main.async {
                let tabVC = self.storyboard!.instantiateViewController(identifier: "ListViewController")
                tabVC.modalPresentationStyle = .fullScreen
                self.present(tabVC, animated: true, completion: nil)
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
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!, options: [:], completionHandler: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
