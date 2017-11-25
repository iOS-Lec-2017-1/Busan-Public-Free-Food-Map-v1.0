//
//  TotalMapViewController.swift
//  FreeFood
//
//  Created by 김종현 on 2017. 11. 12..
//  Copyright © 2017년 김종현. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TotalMapViewController: UIViewController {
    
    @IBOutlet weak var myMapView: MKMapView!
    var locationManager: CLLocationManager!
    var tItems:[[String:String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 현재 위치 트랙킹
        locationManager = CLLocationManager()
        //locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //locationManager.startUpdatingHeading()
        
        // 지도에 현재 위치 마크를 보여줌
        myMapView.showsUserLocation = true
        
        self.title = "부산 무료급식소 지도"
        zoomToRegion()
        
        //print("tItems = \(tItems)")
        // lat, lng
        var annos = [MKPointAnnotation]()
        
        for item in tItems {
            let anno = MKPointAnnotation()
            
            let lat = item["lat"]
            let long = item["lng"]
            
            let fLat = (lat! as NSString).doubleValue
            let fLong = (long! as NSString).doubleValue
            
            anno.coordinate.latitude = fLat
            anno.coordinate.longitude = fLong
            anno.title = item["loc"]
            anno.subtitle = item["addr"]
            
            annos.append(anno)
            
        }
        //myMapView.showAnnotations(annos, animated: true)
        myMapView.addAnnotations(annos)
        myMapView.selectAnnotation(annos[0], animated: true)
        
    }

    func zoomToRegion() {
        // 35.162685, 129.064238
        let center = CLLocationCoordinate2DMake(35.162685, 129.083200)
        let span = MKCoordinateSpanMake(0.35, 0.44)
        let region = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(region, animated: true)
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
