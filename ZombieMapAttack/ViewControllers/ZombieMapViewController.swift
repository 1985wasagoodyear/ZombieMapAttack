//
//  ZombieMapViewController.swift
//  ZombieMapAttack
//
//  Created by K Y on 6/19/19.
//  Copyright © 2019 KY. All rights reserved.
//

// import Foundation
import UIKit

// import CoreLocation
import MapKit

class Zombie {
    
}

class ZombieViewModel {
    var location: CLLocation? {
        didSet {
            if location != nil {
                makeZombies()
            }
        }
    }
    
    var zombies = [Zombie]()
    var updateUI: ()->()
    
    init(_ updateUI: @escaping ()->()) {
        self.updateUI = updateUI
    }
    
    func makeZombies() {
        guard let loc = location,
            zombies.isEmpty == true else {
            return
        }
        // make zombies
    }
}

class ZombieMapViewController: UIViewController {

    // MARK: - XIB Outlets
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Services
    
    let locationManager = LocationManager()
    var vm: ZombieViewModel!
    
    // MARK: - Map Annotation Properties
    
    // MKAnnotation - protocol for annotations
    // MKPointAnnotation - basic annotation class
    var annotations = [MKPointAnnotation]()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = ZombieViewModel({ })
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.start()
        // goToLasVegas()
        
        
    }


}

extension ZombieMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView!
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
            annotationView = view
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: "annotation")
            let image = UIImage(named: "zombie.png")!
            annotationView.image = image
            annotationView.detailCalloutAccessoryView = UIImageView(image: image)
        }
        annotationView.annotation = annotation
        return annotationView
    }
    
}

extension ZombieMapViewController: LMDelegate {
    func didUpdate(_ location: CLLocation!) {
        guard let loc = location else { return }
        let center = loc.coordinate
        let span = MKCoordinateSpan(latitudeDelta: .degrees(miles: 2),
                                    longitudeDelta: .degrees(miles: 2))
        // center - center of the map
        // span - how zoomed-in are we?
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        mapView.setRegion(region,
                          animated: true)
        vm.location = loc
        showTempZombies(loc)
    }
}


extension ZombieMapViewController {
    // only appear once
    // in a circle around you
    func showTempZombies(_ location: CLLocation) {
        if annotations.isEmpty == false {
            return
        }
        var tempAnnotations = [MKPointAnnotation]()
        
        // 4 zombies
        let first = MKPointAnnotation()
        var firstCoord = location.coordinate
        firstCoord.latitude += .degrees(miles: 0.5)
        first.coordinate = firstCoord
        tempAnnotations.append(first)
        
        let second = MKPointAnnotation()
        var secondCoord = location.coordinate
        secondCoord.longitude += .degrees(miles: 0.5)
        second.coordinate = secondCoord
        tempAnnotations.append(second)
        
        let third = MKPointAnnotation()
        var thirdCoord = location.coordinate
        thirdCoord.latitude -= .degrees(miles: 0.5)
        third.coordinate = thirdCoord
        tempAnnotations.append(third)
        
        let fourth = MKPointAnnotation()
        var fourthCoord = location.coordinate
        fourthCoord.longitude -= .degrees(miles: 0.5)
        fourth.coordinate = fourthCoord
        tempAnnotations.append(fourth)
        
        annotations = tempAnnotations
        
        // add our zombies to the map
        mapView.addAnnotations(annotations)
    }
    
    func showZombies() {
        
        
    }
    
    func goToLasVegas() {
        let center = CLLocationCoordinate2D.lasVegas
        let span = MKCoordinateSpan(latitudeDelta: .degrees(miles: 10),
                                    longitudeDelta: .degrees(miles: 10))
        // center - center of the map
        // span - how zoomed-in are we?
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        mapView.setRegion(region,
                          animated: true)
    }
}
