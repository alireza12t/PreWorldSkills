//
//  CenterListViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire
import MapKit

enum CenterListState {
    case map, list
}


class CenterListViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    @IBAction func listButtonDidTap(_ sender: Any) {
        if state != .list {
            state = .list
            updateUIWithState()
        }
    }
    
    @IBAction func mapButtonDidTap(_ sender: Any) {
        if state != .map {
            state = .map
            updateUIWithState()
        }
    }
    
    var state: CenterListState = .list
    var centers: [CenterListElement] = []
    var locationManager = CLLocationManager()
    var annotations: [CustomAnnotation] = []
    var currentLocation = CLLocationCoordinate2D(latitude: 35.761210, longitude: 51.404295)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        setupUI()
        updateUIWithState()
        getCenters()
    }
    
    func setupUI() {
        listButton.addBorder(cornerRadius: 14, color: .brandGreen, borderWidth: 2)
        mapButton.addBorder(cornerRadius: 14, color: .brandGreen, borderWidth: 2)
        mapView.roundUp(14)
    }
    
    func updateUIWithState() {
        switch state {
        case .map:
            mapView.isHidden = false
            tableView.isHidden = true
            makeButtonSelected(mapButton)
            makeButtonUnSelected(listButton)
            updateMapCurrentLocation()
        case .list:
            mapView.isHidden = true
            tableView.isHidden = false
            makeButtonSelected(listButton)
            makeButtonUnSelected(mapButton)
        }
    }
    
    func makeButtonSelected(_ button: UIButton) {
        button.backgroundColor = .brandGreen
        button.setTitleColor(.white, for: .normal)
    }
    
    func makeButtonUnSelected(_ button: UIButton) {
        button.backgroundColor = .clear
        button.setTitleColor(.brandGreen, for: .normal)
    }
    
    func getCenters() {
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
        let url = "http://api.alihejazi.me/Center/GetList/"
        let headders = HTTPHeaders([HTTPHeader(name: "Authorization", value: StoringData.token)])
        
        AF.request(url, method: .get, headers: headders)
            .responseDecodable(of: CenterList.self) { (response) in
                switch response.result {
                case .success(let model):
                    self.centers = model
                    DispatchQueue.main.async {
                        self.mapView.removeAnnotations(self.annotations)
                        self.annotations = self.centers.map { (item) -> CustomAnnotation in
                            CustomAnnotation(name: item.name, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), data: item)
                        }
                        self.mapView.addAnnotations(self.annotations)
                        self.tableView.reloadData()
                        self.loadingIndicatorView.isHidden = true
                        self.loadingIndicatorView.stopAnimating()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BannerManager.showMessage(errorMessageStr: "خطا در دریافت اطلاعات مراکز")
                    DispatchQueue.main.async {
                        self.loadingIndicatorView.isHidden = true
                        self.loadingIndicatorView.stopAnimating()
                    }
                }
            }
    }
    
    func openCenterDetailViewController(id: String) {
        let vc = CenterDetailViewController.instantiateFromStoryboardName(storyboardName: .Main)
        vc.id = id
        Coordinator.pushViewController(sourceViewController: self, destinationViewController: vc)
    }
}

extension CenterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return centers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if centers.indices.contains(indexPath.row) {
            let cellData = centers[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CenterItemTableViewCell", for: indexPath) as! CenterItemTableViewCell
            cell.fillCell(with: cellData)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if centers.indices.contains(indexPath.row) {
            let cellData = centers[indexPath.row]
            openCenterDetailViewController(id: String(cellData.id))
        }
    }
}

extension CenterListViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation!.isKind(of: MKUserLocation.self){
            return
        }
        
        if let customAnnotation = view.annotation as? CustomAnnotation {
            if let data = customAnnotation.data {
                let customView = CustomCallout()
                customView.fillCalloutView(with: data)
                let calloutViewFrame = customView.frame;
                customView.frame = CGRect(x: view.calloutOffset.x - 110, y: calloutViewFrame.size.height - 130, width: 220, height: 90)
                view.addSubview(customView)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for childView:AnyObject in view.subviews{
            if childView.isKind(of: CustomCallout.self) {
                childView.removeFromSuperview();
            }
        }
        if view.annotation!.isKind(of: MKUserLocation.self){
            return
        }
        
        if let customAnnotation = view.annotation as? CustomAnnotation {
            if let data = customAnnotation.data {
                openCenterDetailViewController(id: String(data.id))
            }
        }
        
    }
    
    func updateMapCurrentLocation() {
        if !hasLocationPermission() {
            let alertController = UIAlertController(title: "نیاز به دسترسی لوکیشن داریم", message: "لطفا آن را در تنظیمات فعال کنید", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "تنظیمات", style: .default, handler: {(cAlertAction) in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "لغو", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                fatalError()
            }
        } else {
            hasPermission = false
        }
        return hasPermission
    }
    
}

extension CenterListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            currentLocation = location.coordinate
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
