//
//  StoreSearchViewController.swift
//  FinalProject
//
//  Created by Daniel Koberstein on 4/29/18.
//  Copyright © 2018 Daniel Koberstein. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StoreSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var storeListLabel: UILabel!
    var locationManager: CLLocationManager!
    var geoCoder = CLGeocoder()
    var zoomed: Bool = false
    
    override func viewDidLoad() {
        navigationItem.prompt = "Resell Tracker"
        navigationItem.title = "Shoe Store Finder"
        super.viewDidLoad()
        
        
        
        initializeLocation()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        findShoeStores()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchHandler (response: MKLocalSearchResponse?, error: Error?) {
        if let err = error {
            print("Error occured in search: \(err.localizedDescription)")
        } else if let resp = response {
            print("\(resp.mapItems.count) matches found")
            self.mapKitView.removeAnnotations(self.mapKitView.annotations)
            storeListLabel.text = ""
            var i = 1
            for item in resp.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.mapKitView.addAnnotation(annotation)
                if(i<=5){
                    let storeName = item.name?.replacingOccurrences(of: "Z", with: "z")
                    
                    storeListLabel.text = storeListLabel.text! + "\n" +  String(i) + ".) " + storeName!
                    i = i + 1
                }
            }
        }
        
        
    }
    
    func initializeLocation() { // called from start up method
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocation()
        case .denied, .restricted:
            print("location not authorized")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Delegate method called if location unavailable (recommended)
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        NSLog("locationManager error: \(error.localizedDescription)")
    }
    
    // Delegate method called when location changes
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if(!zoomed){
            let location = locations.last
            
            let regionRadius: CLLocationDistance = 10000
            
            
            let myLocation = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, regionRadius*2.0, regionRadius*2.0)
            
            mapKitView.setRegion(myLocation, animated: true)
            zoomed = true
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            self.startLocation()
        } else {
            self.stopLocation()
        }
    }
    func startLocation () {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func stopLocation () {
        locationManager.stopUpdatingLocation()
    }
    
    func lookupLocation() {
        if let location = locationManager.location {
            geoCoder.reverseGeocodeLocation(location, completionHandler: geoCodeHandler)
        }
    }
    
    func geoCodeHandler (placemarks: [CLPlacemark]?, error: Error?) {
        if let placemark = placemarks?.first {
            if let name = placemark.name {
                print("place name = \(name)")
            }
        }
    }
    
    func findShoeStores() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "shoes"
        request.region = mapKitView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: searchHandler)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
