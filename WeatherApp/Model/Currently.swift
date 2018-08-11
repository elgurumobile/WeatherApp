//
//  Currently.swift
//  WeatherApp
//
//  Created by Felipe Aragon on 8/10/18.
//  Copyright © 2018 Felipe Aragon. All rights reserved.
//

import Foundation

struct Currently: Codable {
    var summary: String
    var icon: String
    var precipType:String
    var precipProbability: Float
    var temperature: Float
    var humidity: Float
}
