//
//  ViewController.swift
//  WeatherApp
//
//  Created by Felipe Aragon on 8/9/18.
//  Copyright © 2018 Felipe Aragon. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    //Variables
   private var weatherInfo:Observable<Any>?
   private let disposeBag = DisposeBag()
   @IBOutlet weak var countryNameLabel: UILabel!
   @IBOutlet weak var temperatureLabel: UILabel!
   @IBOutlet weak var humidityLabel: UILabel!
   @IBOutlet weak var precipTypeLabel: UILabel!
   @IBOutlet weak var precipLabel: UILabel!
   @IBOutlet weak var summaryLabel: UILabel!
   @IBOutlet weak var btnRefresh: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherbyLocation()
    }

    func getWeatherbyLocation()  {
        let geolocationService = GeolocationService.instance
   
        geolocationService.autorized.asObservable().subscribe(onNext: {code in
            switch code{
                case .denied:
                    self.showLocationDisabledPopUp()
                default: ()
            }
        }).disposed(by: disposeBag)
        
        geolocationService.location.asObservable().subscribe(onNext: {location in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: {
                placemarks, error in
                if let placemarkArray = placemarks,let placemark = placemarkArray.first,let name = placemark.name, let locality = placemark.locality, let country = placemark.country
                {
                    self.countryNameLabel.text = "\(name) - \(locality) - \(country)"
                }
            })
        }).disposed(by: disposeBag)
    self.weatherInfo=geolocationService.location.asObservable().flatMapLatest( {location -> Observable<Any> in
              return ApiWeather.shared.getWeather(coordinates: location.coordinate)})
        .observeOn(MainScheduler.instance)
        
        weatherInfo?.asObservable().subscribe({ weatherInfo in
            if  weatherInfo.element is WeatherInfo{
                let element = weatherInfo.element as! WeatherInfo
                    self.temperatureLabel.text = "\(String(describing: element.currently.temperature))°"
                    self.humidityLabel.text = "\(String(describing: element.currently.humidity * 100))%"
                    self.precipLabel.text = "\(String(describing: element.currently.precipProbability * 100))%"
                    self.precipTypeLabel.text = "\(String(describing: (element.currently.precipType.uppercased())))"
                    self.summaryLabel.text = element.currently.summary
            }
        }).disposed(by: disposeBag)
        
        btnRefresh.rx.tap.subscribe({  _ in
           geolocationService.update()
        }).disposed(by: disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController{
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",message: "we need your location",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }

}


