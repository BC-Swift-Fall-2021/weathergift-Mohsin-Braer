//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/4/21.
//

import Foundation

class WeatherLocation: Codable
{
    var name: String;
    var latitide: Double;
    var longitude: Double;
    
    init(name: String, latitude: Double, longitude: Double)
    {
        self.name = name;
        self.latitide = latitude;
        self.longitude = longitude;
    }
}
