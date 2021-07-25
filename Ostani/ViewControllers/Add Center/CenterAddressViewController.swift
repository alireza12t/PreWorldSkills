//
//  CenterAddressViewController.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import UIKit
import MapKit

class CenterAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        if let address = addressTextField.text, !address.isEmpty {
            model?.address = address
            model?.latitude = currentLocation.latitude
            model?.longitude = currentLocation.longitude
            let vc = CenterImageViewController.instantiateFromStoryboardName(storyboardName: .Main)
            vc.model = model
            Coordinator.pushViewController(sourceViewController: self, destinationViewController: vc)
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    var model: AddCenterBody? = nil
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D(latitude: 35.761210, longitude: 51.404295)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        setupUI()
        handleKeyboardIssues()
    }
    
    func handleKeyboardIssues() {
        let textfields = [addressTextField]
        addressTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
    }
    
    func setupUI() {
        backButton.roundUp(14)
        nextButton.roundUp(14)
        addressTextField.roundUp(20)
        mapView.roundUp(20)
    }
    
}

extension CenterAddressViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            currentLocation = location.coordinate
            locationManager.stopUpdatingLocation()
            updateLocationText(coordinate: currentLocation)
        }
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateLocationText(coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        geoCoder.accessibilityLanguage = "fa"
        let location = CLLocation(latitude: coordinate.latitude, longitude:  coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "fa"), completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                self.addressTextField.text = "\(placemark.locality ?? "") - \(placemark.name ?? "")"
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.region.center
        updateLocationText(coordinate: center)
        currentLocation = center
    }
}
