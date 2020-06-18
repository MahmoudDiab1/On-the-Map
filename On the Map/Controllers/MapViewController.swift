//
//  MapViewController.swift
//  On the Map
//
//  Created by mahmoud diab on 6/15/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate{
    
    // MARK:- Outlets
    @IBOutlet weak var mapKitOutlet: MKMapView!
    
    
    // MARK:- Instances
    var annotations = [MKPointAnnotation]()
    var locationManager = CLLocationManager()
    
    
    // MARK:- App lifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.mapKitOutlet.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitOutlet.delegate = self
        LocationClient.getLocationsOrdere(completion: handleLocationResponse(result:))
    }
    
    
    
    
    //MARK:- IB Actions
    // Add new student location
    @IBAction func addLocationPressed(_ sender: Any) {
        guard let NavController = storyboard?.instantiateViewController(identifier: "NavController") as? NavController else {return}
        NavController.modalPresentationStyle = .fullScreen
        NavController.modalTransitionStyle = .flipHorizontal
        present(NavController,animated: true,completion: nil)
    }
    
    
    // Logout
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserClient.studentLogout(deleteSessionId: Session.loggedSession.id, expireAt: Session.loggedSession.expiration, completion: handleLogoutResponse(deactivateSession:error:))
    }
    
    func handleLogoutResponse(deactivateSession: Bool?, error: Error?) {
        if deactivateSession == true {
            Session.loggedSession.id = ""
            Session.loggedSession.expiration = ""
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            alertMessage(title: "Failed to logout!", message: "Cheack your internet connection and Try again.")
        }
    }
    
    // Reload Data.
    @IBAction func reloadPressed(_ sender: Any) {
        LocationClient.reload(completion: handleStudentInfo(result:))
    }
    func handleStudentInfo(result:Result<Locations?, Error>){
        switch result {
        case .success(let studentInfo):
            if let studentInfo = studentInfo {
                for i in studentInfo.results {
                    let name = i.firstName
                    let secondName = i.lastName
                    let fullName = String("\(name) \(secondName)")
                    let student = StudentTableData(studentName: fullName, studentURL: i.mediaURL)
                    StudentTableData.student.append(student)
                }
                self.mapKitOutlet.reloadInputViews()
            }
        case .failed( _):
            // print(error)
            alertMessage(title: "Error", message: "Can't retrieve data , chck your network connection or data")
        }
    }
    
    
    // Alert message tool
    func alertMessage(title:String,message:String?) {
        let alertVC = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    
    // MARK:- Helpers and Functions
    
    /*  HandleLocationResponse.
     1- Filter annotation attributes from each item of locationList(Response) by (getAnnotation Function).
     2- Check if there is stored Location by user (in case he add new location) to update annotions array by it and other result from API.
     3- Populate array of annotations contains annotations from API and stored Location at (Location.studentLocation*Singltone*)If user added Location.
     */
    func handleLocationResponse ( result:Result<Locations?, Error> ) {
        switch result {
        case .success(let locations):
            guard let locationList = locations?.results else { return }
            
            for  location in locationList {
                getAnnotationData(firstName: location.firstName, lastName: location.lastName, url: location.mediaURL, lat: location.latitude, long: location.longitude)
            }
            
            
            if StudentInformation .studentLocation.latitude != 0.0 {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: StudentInformation .studentLocation.latitude, longitude: StudentInformation .studentLocation.longitude)
                annotation.title = String("\(StudentInformation .studentLocation.firstName)\(StudentInformation .studentLocation.lastName)")
                annotation.subtitle = StudentInformation .studentLocation.mediaURL
                annotations.append(annotation)
                self.mapKitOutlet.reloadInputViews()
                self.zoomToUserLocation(latitude: StudentInformation .studentLocation.latitude, longitude: StudentInformation .studentLocation.longitude)
            } else {
                self.mapKitOutlet.reloadInputViews()
            }
            self.mapKitOutlet.addAnnotations(annotations)
            
        case .failed( _):
            // print(error)
            alertMessage(title: "Failed to setup the Map data", message: "Check your network Connection")
        }
    }
    
    ///Populate MKPointAnnotation object from parameters (firstName,lastName,url,lat,long)
    /// to be assigned to array of annotations
    func getAnnotationData(firstName:String,lastName:String,url:String,lat:Double,long:Double) {
        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(lat)
        let long = CLLocationDegrees(long)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = "\(firstName)\(lastName)"
        annotation.subtitle = url
        annotations.append(annotation)
    }
    
    // function that incapsulates the feature of zooming into the location based on passed lang , lat .*/
    func zoomToUserLocation(latitude: Double, longitude: Double) {
        let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 400000, longitudinalMeters: 400000)
        mapKitOutlet.setRegion(viewRegion, animated: false)
        mapKitOutlet.showsUserLocation = true
    }
    
    
    
    
    //    MARK:- MKMapView delegate functions
    
    // PinView population
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            guard let pinView = pinView else { return nil }
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // interactive pressing on pinView (open data by tap )
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let url = URL(string: (String(describing: view.annotation?.subtitle))) else {  alertMessage(title: "Failed to open url", message: "Unable to get student link. Check if link is complete."); return}
        guard ( UIApplication.shared.canOpenURL(url) )  else {
            alertMessage(title: "Failed to open url", message: "Unable to get student link. Check if link is complete.")
            return
        }
    }
    
    
}
