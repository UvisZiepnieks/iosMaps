//
//  ViewController.swift
//  Lekcija3
//
//  Created by Students on 06/03/2019.
//  Copyright © 2019 students. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, secondControllerDelagate,  ThirdViewControllerDelegate {


    var placemarks = [Place]()
    var locationManager = CLLocationManager()
    var sumtingwong = [[String]]()
    
    
    @IBOutlet weak var myTextView: UITextField!
    
    
    @IBOutlet weak var Controler: MKMapView!
    var mansTexts = "Nav teksts ievadīts"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            Controler.showsUserLocation = true
            
            let Valmiera = Place(title: "Valmiera",
                                      des: "Valmiera",
                                      coordinate: CLLocationCoordinate2D(latitude: 57.535067, longitude: 25.424228))
            let Sigulda = Place(title: "Sigulda",
                                       des: "Sigulda",
                                       coordinate: CLLocationCoordinate2D(latitude: 57.143337, longitude: 24.854284))
            
            
           let Saulkrasti = Place(title: "Saulkrasti",
                                      des: "Saulkrasti",
                                      coordinate: CLLocationCoordinate2D(latitude: 57.268759, longitude: 24.426470))
            placemarks.append(contentsOf:[Valmiera,Sigulda,Saulkrasti])
         Controler.addAnnotations(placemarks)
          
            
        }
       
    }
 
    func ArrayUpdated(newArray: [[String]]) {
        for row in newArray {
            let loc = MKPointAnnotation()
            if let latt = Double(row[0]), let longg = Double(row[1]) {
                loc.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                Controler.addAnnotation(loc)
                print("This row: " + row[0])
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewAdd", let vc = segue.destination as? ThirdViewController{
            vc.delegate = self
        }
        
        if segue.identifier == "toFilterView" {
            if let secondViewController = segue.destination as? SecondViewController {
                secondViewController.mansTextsNoMainVC = mansTexts
            }
        }
  
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        for row in sumtingwong {
            let loc = MKPointAnnotation()
            if let latt = Double(row[0]), let longg = Double(row[1]) {
                loc.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                Controler.addAnnotation(loc)
                print("This row: " + row[0])
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations =\(locValue.latitude)\(locValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 105000,  longitudinalMeters: 135000)
        self.Controler.setRegion(viewRegion, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "placemarks"
        if annotation is Place {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            }else{
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Place
        let placeName = location.title
        let description = location.des
        
        let showus = UIAlertController(title: placeName, message: description, preferredStyle: .alert)
        showus.addAction(UIAlertAction(title: "Aiziet", style: .default, handler: {(ac:UIAlertAction!) in self.Click(view: view)}))
        present(showus,animated: true, completion: nil)
    }
    
    func Click(view: MKAnnotationView){
        if let annotation = view.annotation{
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(0, 0)))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate{ response, error in
                if let route = response?.routes.first {
                    self.Controler.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
            
        }else{
            //no annotation
        }
        
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 2
        
        return renderer
    }

    func distance10kfilter(distance: Bool) {
        if distance == true {
            let myLocation = CLLocation(latitude: Controler.userLocation.coordinate.latitude, longitude: Controler.userLocation.coordinate.longitude)
            
            for locations in placemarks{
                let pinLocation = CLLocation(latitude: locations.coordinate.latitude,longitude: locations.coordinate.longitude)
                let distance = myLocation.distance(from: pinLocation) / 1000
                if (distance > 10){
                    Controler.removeAnnotation(locations)
                }else{
                    //nothing
                }
            }
        }else{
            Controler.addAnnotations(placemarks)
        }
    }
    
    func descriptionFilter(description: Bool) {
        if description == true{
            for locations in placemarks{
                if(locations.description == ""){
                    Controler.removeAnnotation(locations)
                }else{
                    //nothing
                }
            }
        }else{
            Controler.addAnnotations(placemarks)
        }
    }
    
   
    
    func Controler(_ Controler: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?{
        
        
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "Annotation"
        var annotationView = Controler.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }else{
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            Controler.showsUserLocation = true
            break
        case .denied:
            //show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert
            break
        case .authorizedAlways:
            break
        }
    }
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
            
        }else{
            //alert
        }
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
       
    
        
        
        
    }

    @IBAction func LoadArray(_ sender: UIButton) {
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toViewAdd" {
//            if let thirdViewController = segue.destination as? ThirdViewController {
//                thirdViewController.mansTextsNoMainVC = mansTexts
//            }
//        }
//    }
}

