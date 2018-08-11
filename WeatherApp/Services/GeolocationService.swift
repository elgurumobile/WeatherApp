//
//  GeolocationService.swift
//  WeatherApp
//
//  Created by Felipe Aragon on 8/10/18.
//  Copyright © 2018 Felipe Aragon. All rights reserved.
//
import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class GeolocationService {
    
    static let instance = GeolocationService()
    private (set) var autorized: Observable<CLAuthorizationStatus>
    private (set) var location: Observable<CLLocation>
    
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    private init() {
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        autorized = locationManager.rx.didChangeAuthorizationStatus
            .startWith(CLLocationManager.authorizationStatus())
            .asObservable()
            .map {$0}
        
        location = locationManager.rx.didUpdateLocations
            .asObservable()
            .filter { $0.count > 0 }
            .map { $0.last!}
        
        location.asObservable().subscribe(onNext: { [unowned self] _ in
            self.locationManager.stopUpdatingLocation()
        }).disposed(by: disposeBag)
        
        locationManager.requestAlwaysAuthorization()
        update()
    }
    
    func update() {
        locationManager.startUpdatingLocation()
    }
    

}
