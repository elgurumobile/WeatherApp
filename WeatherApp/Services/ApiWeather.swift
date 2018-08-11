//
//  ApiSpotify.swift
//  SpotifyApp
//
//  Created by Felipe Aragon on 7/24/18.
//  Copyright © 2018 Felipe Aragon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


class ApiWeather {
    
    static var shared = ApiWeather()
    
    /// The URL string
    func urlString(coordinates: CLLocationCoordinate2D) -> URL {
        let urlString = String(format:Constants.Weather.urlWeather+"\(coordinates.latitude),\(coordinates.longitude)")
        let url = URL(string: urlString)
        return url!
    }
    
    /// Parse JSON data
    func parse(data: Data) -> Any? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(WeatherInfo.self, from:data)
            return result
            
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    /// Make API request
    func getWeather(coordinates: CLLocationCoordinate2D) -> Observable<Any> {
        
        let url = urlString(coordinates: coordinates)
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        return session.rx.data(request: request).map { data in
            if let parseData = self.parse(data: data){
                return parseData
            }else{
                return Observable.just("")
            }
        }
    }
    
}
