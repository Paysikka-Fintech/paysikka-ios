//
//  StoresLocatorController.swift
//  Paysikka
//
//  Created by George Praneeth on 22/10/22.
//

import UIKit
import MapKit

class StoresLocatorController: UIViewController {

    @IBOutlet weak var storesMap: MKMapView!
    
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        customPin(coordinate: CLLocationCoordinate2D(latitude: 17.444940, longitude: 78.457190))
        customPin(coordinate: CLLocationCoordinate2D(latitude: 17.458031, longitude: 78.459106))
        customPin(coordinate: CLLocationCoordinate2D(latitude: -5.113700, longitude: 105.306557))
        
    }
    
    func checkLocationServices() {
        
        setupLocationManager()
        checkLocationAuthorization()
       
//        if CLLocationManager.locationServicesEnabled() {
//
//            setupLocationManager()
//            checkLocationAuthorization()
//
//        } else {
//
//           print("Location Not Enabled")
//        }
        
    }
    
    
    func getCenterLocation() -> CLLocation {
        let latitude = storesMap.centerCoordinate.latitude
        let longitude = storesMap.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func setupLocationManager() {
        storesMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
      
    }
    
    func startTackingUserLocation() {
        storesMap.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
       // previousLocation = getCenterLocation()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse,.authorizedAlways:
            startTackingUserLocation()
        case .denied,.restricted:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified, please open this app's settings and set location access to 'AuthorizedWhenInUse'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    
    func centerViewOnUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                storesMap.setRegion(region, animated: true)
        }
    }
    
    func customPin(coordinate:CLLocationCoordinate2D){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Custom Pin"
        pin.subtitle = "SubTitle"
        storesMap.addAnnotation(pin)
    }
    
    
}

extension StoresLocatorController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
    guard !(annotation is MKUserLocation) else {return nil}
        
    var annotationView = storesMap.dequeueReusableAnnotationView(withIdentifier: "custom")
    
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "location")
        
    return annotationView
        
    }
    
}

extension StoresLocatorController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let center = locations.first else { return }
       
        if let locationCoordinate = locations.first?.coordinate{
               customPin(coordinate: locationCoordinate)
        }
        
        let geoCoder = CLGeocoder()
        
//        guard let previousLocation = self.previousLocation else { return }
//
//        guard center.distance(from: previousLocation) > 50 else { return }
//        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let region = placemark.region
            let location = placemark.location
            let country = placemark.country
            let locality = placemark.locality
            let name = placemark.name
            let postalCode = placemark.postalCode
            let administrativeArea = placemark.administrativeArea
            
            DispatchQueue.main.async {
                
            self.storesMap.region = MKCoordinateRegion(center: center.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.locationManager.stopUpdatingLocation()
           
            }
            
            
           print("streetNumber: \(streetNumber)","streetName: \(streetName)","region: \(String(describing: region))","location: \(location)","country: \(country)","locality: \(locality)","name: \(name)","postalCode: \(postalCode)","administrativeArea: \(administrativeArea)")
           
        }
        
    }
    
}
