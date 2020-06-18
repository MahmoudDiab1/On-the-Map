//
//  addLocation.swift
//  On the Map
//
//  Created by mahmoud diab on 6/18/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import MapKit
class AddLocation: UIViewController ,UITextFieldDelegate{
    
    //    MARK:- outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var homeTown: UITextField!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var FindButton: UIButton!
    
    
    var keyboardHight : CGFloat=0
    //    MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene(isActive: true)
        mediaURL.delegate = self
        homeTown.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScene(isActive: true)
        self.subscribeToKeyboardNotifications()
    }
    
    
    
    //    MARK:- Actions
    /*  shwo user location on the map
     1- Validate fields aren't empty or one of them is empty.
     2- convert homeTown with string data type to map string using geocoder
     3- save url and home town to Location.studentLocation and waiting to fill its other data.
     4- request to get current user data by user key stored at (Account.account.key)and assign result into Location.studentLocation to complete its initialization.
     */
    
    @IBAction func FindOnTheMapPressed(_ sender: Any) {
        setupScene(isActive:false)
        if let urlText = mediaURL.text  {
            if urlText != " " {
                print(urlText)
                StudentInformation .studentLocation.mapString = urlText
            } else {
                alertMessage(title: "Fill all fields", message: "Unable to get student information. Fill in the link to share.")
                setupScene(isActive: true)
                return
            }
        } else {
            alertMessage(title: "Fill all fields", message: "Unable to get student information. Fill in the link to share.")
            setupScene(isActive: true)
            return
        }
        
        if let location = homeTown.text  {
            if location != " " {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        self.alertMessage(title: "Not existed",message: "Enter a correct place.")
                        self.setupScene(isActive: true)
                    }
                })
                StudentInformation.studentLocation.mapString = location
                
                
                // Inside login function I catch session id and assign it to ( Account.account.key ) to use it here as parameter.
                let userKey = Account.account.key
                print(location)
                UserClient.getUserDataRequest(userKey: userKey, completion: self.handleGetUserDataRequest(result:))
            } else {
                alertMessage(title: "Fill all fields", message: "Unable to get student information. Fill in a correct hometown.")
                setupScene(isActive: true)
                return
            }
        } else {
            alertMessage(title: "Fill all fields", message: "Unable to get student information. Fill in a correct hometown.")
            setupScene(isActive: true)
            return
        }
    }
    
    
    // Cancel to dismiss the view
    @IBAction func cancelButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //    MARK:- Functions and Helpers
    
    // Controle the functionality of views during state of loading and normal.(enable\disable)
    func setupScene(isActive:Bool) {
        if isActive {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            mediaURL.text = " "
            homeTown.text = " "
            FindButton.isEnabled = true
        } else {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            FindButton.isEnabled = false
        }
    }
    
    //    Handle Get User Data Request ( get information by session id "Key")
    func handleGetUserDataRequest (result:Result<UserInformation?,Error>) {
        switch result {
        case .success(let userInfo):
            guard let userInfo = userInfo else { return }
            StudentInformation .studentLocation.firstName = userInfo.firstName
            StudentInformation .studentLocation.lastName = userInfo.lastName
            DispatchQueue.main.async {
                let shareVC = self.storyboard!.instantiateViewController(identifier: "ShareLocation")  as! ShareLocation
                self.navigationController?.pushViewController(shareVC, animated: true)
            }
        case .failed( _):
            // print(error)
            alertMessage(title: "Failed to setup the Map data", message: "Check your network Connection")
            setupScene(isActive: true)
        }
    }
    
    //    Error message alert tool
    func alertMessage(title:String,message:String) {
        let alertVC = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    //    MARK:- keyboard handeling
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)) ,name: UIResponder.keyboardWillShowNotification , object: nil)
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
