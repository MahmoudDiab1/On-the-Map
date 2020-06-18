//
//  ShareLocation.swift
//  On the Map
//
//  Created by mahmoud diab on 6/18/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import MapKit
class ShareLocation: UIViewController,MKMapViewDelegate {
    //    MARK:- outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Properties
    var latitude: Double!
    var longitude: Double!
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        enteredLocation(location: StudentInformation .studentLocation.mapString, link: StudentInformation .studentLocation.mediaURL, name: String("\(StudentInformation .studentLocation.firstName) \(StudentInformation .studentLocation.lastName)"))
    }
    
    
    
    // MARK: -Actions
    @IBAction func submitButtonPressed(_ sender: Any) {
        let location = StudentInformation .studentLocation
        LocationClient.postUserLocation(userLocationData: location, completion: handleAddStudentResponse(result:))
    }
    func handleAddStudentResponse(result:Result<LocationResponse?, Error>) {
        switch result {
        case .success( _):
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        case .failed( _):
            // print(error)
            alertMessage(title: "Failed to setup the Map data", message: "Check your network Connection")
        }
    }
    
    
    //MARK:- Helpers and Functions
    func enteredLocation(location: String, link: String, name: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                // print(error)
                self.alertMessage(title: "Failed to setup the Map data", message: "Check your network Connection")
            }
            
            
            if let placemark = placemarks?.first {
                
                guard let coordinates = placemark.location?.coordinate else { return }
                self.latitude = coordinates.latitude
                self.longitude = coordinates.longitude
                // Next step is the las step of initializing  Location.studentLocation.latitude after 2 steps .( Dive into AddLocationViewController )
                
                StudentInformation .studentLocation.latitude = coordinates.latitude
                StudentInformation .studentLocation.longitude = coordinates.longitude
                
                self.zoomToUserLocation(latitude: self.latitude, longitude: self.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = name
                annotation.subtitle = link
                self.mapView.addAnnotation(annotation)
                self.mapView.reloadInputViews()
            }
        })
    }
    
    // function that incapsulates the feature of zooming into the location based on passed lang , lat .*/
    func zoomToUserLocation(latitude: Double, longitude: Double) {
        let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 400000, longitudinalMeters: 400000)
        mapView.setRegion(viewRegion, animated: false)
        mapView.showsUserLocation = true
    }
    
    //    Error message alert tool
    func alertMessage(title:String,message:String?) {
        let alertVC = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    
    

    
    
    
    //    MARK:- mapView delegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // interactive pressing on pinView (open data by tap )
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let url = URL(string: (String(describing: view.annotation?.subtitle))) else { alertMessage(title: "Failed to open url", message: "Unable to get student link. Check if link is complete."); return}
        guard ( UIApplication.shared.canOpenURL(url) )  else {
            alertMessage(title: "Failed to open url", message: "Unable to get student link. Check if link is complete.")
            return
        }
    }
}
