//
//  MainVC.swift
//  Project22.DectectABeacon
//
//  Created by SCOTT CROWDER on 6/3/24.
//

import CoreLocation
import UIKit

enum DistanceToBeacon {
    case far, immediate, near, unknown
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
            view.backgroundColor = .orange
            distanceReading.text = "NEAR"
        case .far:
            view.backgroundColor = .blue
            distanceReading.text = "FAR"
        case .immediate:
            view.backgroundColor = .red
            distanceReading.text = "RIGHT HERE"
        default:
            view.backgroundColor = .gray
            distanceReading.text = "UNKNOWN"
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
    
    private func startScanning() {
        guard let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") else { return }
        
//        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
//        locationManager?.startMonitoring(for: beaconRegion)
//        locationManager?.startRangingBeacons(satisfying: beaconRegion)
        
        let beaconIdentity = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        locationManager?.startRangingBeacons(satisfying: beaconIdentity)
    }
    
    private func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.changeBackgroundColor(beaconDistance: .far)
            case .near:
                self.changeBackgroundColor(beaconDistance: .near)
            case .immediate:
                self.changeBackgroundColor(beaconDistance: .immediate)
            default:
                self.changeBackgroundColor(beaconDistance: .unknown)
            }
        }
    }
}

extension MainVC: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}
