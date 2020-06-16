//
//  ViewController.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import MapKit
 
class ViewController: UIViewController , MKMapViewDelegate{
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapKitOutlet: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userName = "diab85377@gmail.com"
        let password = "Mahmoudios95"
        
         
        APIClient.getUserDataRequest(userName: userName, password: password) { (result:Result<UserInformation?, Error>) in
            switch result
            {
            case .success(let data):
           
                guard let userData = data else {return}
//                print(userData)
            case .failed(let error):
                print("error")
            }
        }
    }
    
    
    
    
}
