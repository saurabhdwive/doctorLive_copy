//
//  LocationViewController.swift
//  DoctorLive
//
//  Created by call soft on 02/09/21.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(lat: String)
    func sendDataToFirstViewController(long: String)
    func sendDataToFirstViewController(adress: String)
}

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var delegate: MyDataSendingDelegateProtocol? = nil
    let locationManager = CLLocationManager()
    var lat, long: String?
    
    //MARK: - Properties
    
    private var mainMapViewModal: MainMapViewModal = MainMapViewModal()
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var doneButton: UIButton!
    let marker = GMSMarker()
    // MARK: - Viewcontroller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        mainMapViewModal.initMap(mapView: mapView)
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 30)
        navigationItem.titleView = mainMapViewModal.setSearchBar()
        definesPresentationContext = true
        doneButton.layer.cornerRadius = 10
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let dataToBeSent = mainMapViewModal.lat ?? ""
        let adresslong = mainMapViewModal.long ?? ""
        let adress = mainMapViewModal.adress ?? ""
        self.delegate?.sendDataToFirstViewController(lat: dataToBeSent)
        self.delegate?.sendDataToFirstViewController(long: adresslong)
        self.delegate?.sendDataToFirstViewController(adress: adress)
        self.navigationController?.popViewController(animated: true)
    }
 }
