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
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let parseCli = ParseClient.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aspectRatio = (Double(mapView.frame.width / mapView.frame.height))
        locationTextField.delegate = self
        linkTextField.delegate = self
        setUIEnabled(true)
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        setUIEnabled(false)
        var update = false
        var objectId : String = ""
        if let _ = delegate.userInfo?.objectId {
            update = true
            objectId = (delegate.userInfo?.objectId)!
        }
        parseCli.addLocation(body: getDetails(), update:update,objectid: objectId, controllerCompletionHandler: {
            data,error in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)

                if let error = error {
                    self.showError(errorString: error)
                    return
                }
                 else {
                    if !update{
                        self.delegate.userInfo?.objectId = ((data as! [String:AnyObject])[ParseClient.JSONResponseKeys.ObjectID] as! String)
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }
            
            
        })
        
        print(getDetails())
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
                alert(title: "Error trying to find place.", message: "Could not find any places matching \(self.locationTextField.text!)", controller: self)
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
    
    func showError(errorString : String){
        alert(title: "Could not post location.", message: errorString, controller: self)
    }
    
    
    func getDetails() -> [String:AnyObject]{
        
        let data = [
            ParseClient.JSONParamKeys.FirstName : delegate.userInfo?.firstName as AnyObject,
            ParseClient.JSONParamKeys.LastName : delegate.userInfo?.lastName as AnyObject,
            ParseClient.JSONParamKeys.MediaURL : linkTextField.text as AnyObject,
            ParseClient.JSONParamKeys.UniqueKey : delegate.user_id as AnyObject,
            ParseClient.JSONParamKeys.MapString : locationTextField.text as AnyObject,
            ParseClient.JSONParamKeys.Lat : mapView.annotations[0].coordinate.latitude as AnyObject,
            ParseClient.JSONParamKeys.Lng : mapView.annotations[0].coordinate.longitude as AnyObject
        
        ]
        
        return data
        
        
    }
    
    func setUIEnabled(_ enabled: Bool) {
        // The code seemed repetitive and in the docs I found they all inherit from UIControl which is how they have the isEnabled. Using UI view it did not work
        let els : [UIControl] = [locateButton, locationTextField, linkTextField, submitBtn]
        
        for el in els{
            el.isEnabled = enabled
            if enabled {
                el.alpha = 1.0
            } else {
                el.alpha = 0.5
            }
        }
        checkSubmit()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false
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

