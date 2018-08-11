//
//  ApiResponse.swift
//  WeatherApp
//
//  Created by Felipe Aragon on 8/10/18.
//  Copyright © 2018 Felipe Aragon. All rights reserved.
//

import Foundation

struct WeatherInfo: Codable {
    var latitude: Double
    var longitude: Double
    var timezone: String
    var currently: Currently
}
