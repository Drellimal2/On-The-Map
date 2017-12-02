//
//  NewLocationViewController.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewLocationViewController: UIViewController {

    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitBtn: UIButton!
    var aspectRatio : Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aspectRatio = (Double(mapView.frame.width / mapView.frame.height))
        locationTextField.delegate = self
        linkTextField.delegate = self
        setUIEnabled(true)
        checkSubmit()
    }

    @IBAction func locate(_ sender: Any){
        if (locationTextField.text?.isEmpty)! {
            alert(title: "Could Not Locate", message: "Location text field cannot be blank", controller: self )
            return
        }
        
        setUIEnabled(false)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text
        
        // Set the region to an associated map view's region
//        request.region = myMapView.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (data, error) in
            
            guard error == nil else{
                self.setUIEnabled(true)
                return
            }
            guard let data = data, data.mapItems.count >= 1 else {
                
                alert(title: "Error trying to find place.", message: "Could not find any places matching \(self.locationTextField.text!)", controller: self)
                print("ehh")
                self.setUIEnabled(true)

                return
            }
            let placemark = data.mapItems[0].placemark
            let coordinate = placemark.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(data.mapItems[0].placemark.title!)"
            // annotation.subtitle = student.mediaURL
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
            guard let region = data.mapItems.first?.placemark.region as? CLCircularRegion else {
                
                alert(title: "Error trying to find place.", message: "Could not find any places matching \(self.locationTextField.text!)", controller: self)
                
                self.setUIEnabled(true)

                return
            }
            
            let hght = region.radius  * 2 + 2000.0
            let wdth = hght * self.aspectRatio
            let mkregion = MKCoordinateRegionMakeWithDistance(region.center, hght, wdth)
            self.mapView.setRegion(mkregion, animated: true)
            
            self.setUIEnabled(true)


        })
        
    }
   

}

extension NewLocationViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        locateButton.isEnabled = enabled
        locationTextField.isEnabled = enabled
        linkTextField.isEnabled = enabled
        submitBtn.isEnabled = enabled
        //
        
        
        if enabled {
            locateButton.alpha = 1.0
            if ((locationTextField.text != nil || mapView.annotations.count > 0) && linkTextField.text != nil){
                submitBtn.isEnabled = true
                submitBtn.alpha = 1.0

            } else {
                submitBtn.isEnabled = false
                submitBtn.alpha = 0.5

                
            }
        } else {
            locateButton.alpha = 0.5
            submitBtn.alpha = 0.5

        }
    }
   
    func checkSubmit(){
        if ((self.locationTextField.text?.isEmpty)! || (self.linkTextField.text?.isEmpty)!) ||
            self.mapView.annotations.count == 0 {
            submitBtn.isEnabled = false
            submitBtn.alpha = 0.5
            submitBtn.titleLabel?.textColor = Consts.grey_color
            return
        }
        submitBtn.isEnabled = true
        submitBtn.alpha = 1
        submitBtn.titleLabel?.textColor = Consts.enabled_blue

        
        
    }
}

extension NewLocationViewController : UITextFieldDelegate {
    
    func UITextFieldTextDidChange(_ textView: UITextField) {
        
        self.checkSubmit()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        self.checkSubmit()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkSubmit()
    }
    
    
    
}

extension NewLocationViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(NSURL(string: toOpen)! as URL)
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.shared
            app.open(NSURL(string: annotationView.annotation!.subtitle!!)! as URL)
        }
    }
    
}

