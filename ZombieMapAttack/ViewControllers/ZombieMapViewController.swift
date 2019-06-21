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

    var id: Int
    
    // MKAnnotation - protocol for annotations
    // MKPointAnnotation - basic annotation class
    var annotation: MKPointAnnotation

    init(id: Int, annotation: MKPointAnnotation) {
        self.id = id
        self.annotation = annotation
    }

}

extension Zombie: Hashable {
    
    static func == (lhs: Zombie, rhs: Zombie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
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

extension CLLocationCoordinate2D {
    static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

class ZombieMapViewController: UIViewController {

    // MARK: - XIB Outlets
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Services
    
    let locationManager = LocationManager()
    var vm: ZombieViewModel!
    
    // MARK: - Map Annotation Properties
    
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        vm.zombies.removeAll {
            guard let viewAnnotation = view.annotation else { return false }
            let res = $0.annotation.coordinate == viewAnnotation.coordinate
            if res == true {
                mapView.removeAnnotation($0.annotation)
            }
            return res
        }
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
        if vm.zombies.isEmpty == false {
            return
        }
        
        // 4 zombies
        let first = MKPointAnnotation()
        var firstCoord = location.coordinate
        firstCoord.latitude += .degrees(miles: 0.5)
        first.coordinate = firstCoord
        let firstZombie = Zombie(id: 1, annotation: first)
        
        let second = MKPointAnnotation()
        var secondCoord = location.coordinate
        secondCoord.longitude += .degrees(miles: 0.5)
        second.coordinate = secondCoord
        let secondZombie = Zombie(id: 2, annotation: second)
        
        let third = MKPointAnnotation()
        var thirdCoord = location.coordinate
        thirdCoord.latitude -= .degrees(miles: 0.5)
        third.coordinate = thirdCoord
        let thirdZombie = Zombie(id: 3, annotation: third)
        
        let fourth = MKPointAnnotation()
        var fourthCoord = location.coordinate
        fourthCoord.longitude -= .degrees(miles: 0.5)
        fourth.coordinate = fourthCoord
        let fourthZombie = Zombie(id: 4, annotation: fourth)
        
        vm.zombies = [firstZombie, secondZombie, thirdZombie, fourthZombie]
        showZombies()
    }
    
    func showZombies() {
        // add our zombies to the map
        mapView.addAnnotations(vm.zombies.map { $0.annotation })
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
