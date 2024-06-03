//
//  MainVC.swift
//  Project22.DectectABeacon
//
//  Created by SCOTT CROWDER on 6/3/24.
//

import CoreLocation
import UIKit

enum DistanceToBeacon {
    case near, far, unknown
}

class MainVC: UIViewController {
    
    var distanceReading: UILabel!
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        configureDistanceReading()
        changeBackgroundColor()
    }
    
    private func changeBackgroundColor(beaconDistance: DistanceToBeacon = .unknown) {
        switch beaconDistance {
        case .near:
            view.backgroundColor = .red
        case .far:
            view.backgroundColor = .yellow
        case .unknown:
            view.backgroundColor = .gray
        }
    }
    
    private func configureDistanceReading() {
        distanceReading = UILabel()
        distanceReading.font = UIFont.systemFont(ofSize: 40, weight: .thin)
        distanceReading.text = "UNKNOWN"
        distanceReading.textColor = .systemGray
        distanceReading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceReading)
        
        NSLayoutConstraint.activate([
            distanceReading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceReading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
}

extension MainVC: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
}
