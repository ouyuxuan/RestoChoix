//
//  ViewController.swift
//  RestoChoix
//
//  Created by Ou Yu Xuan on 2020-10-21.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  var locationManager: CLLocationManager?
  var currLocation: CLLocation!
  lazy var functions = Functions.functions()
  
  @IBAction func startPressed(_ sender: Any) {
  }
  
  @IBAction func currLocPressed(_ sender: Any) {
    setViewToCurrentLocation()
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    getApiKey()
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      currLocation = locationManager?.location
      setViewToCurrentLocation()
    }
  }
  
  func setViewToCurrentLocation() {
    let camera = GMSCameraPosition(latitude: currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude, zoom: 12)
    let mapView = GMSMapView(frame: .zero, camera: camera)
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude)
    marker.map = mapView
    
    self.view = mapView
  }
  
  func getApiKey() {
    functions.httpsCallable("getApiKey").call() { (result, error) in
      if let err = error as NSError? {
        print(err)
      }
      if let key = (result?.data as? [String: Any])?["key"] as? String {
        GMSServices.provideAPIKey(key)
        GMSPlacesClient.provideAPIKey(key)
        print(key)
      }
    }
  }
}

