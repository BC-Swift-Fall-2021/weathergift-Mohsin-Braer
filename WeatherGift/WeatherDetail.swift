//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/11/21.
//

import Foundation

class WeatherDetail: WeatherLocation {
   
     struct Result:  Codable{
        var timezone: String
        var current: Current
    }
    
     struct Current: Codable{
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
     struct Weather: Codable{
        var description: String
        var icon: String
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
    func getData(completed: @escaping () -> ()){
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitide)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherAPIKeys)"
        
        print("")
        
        guard let url = URL(string: urlString) else{
            print("ERROR: Could not create URL")
            completed()
            return
        }
        
        
        let session = URLSession.shared;
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            
            do{
                let result = try JSONDecoder().decode(Result.self, from: data!)
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("\(json)")
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dailyIcon = result.current.weather[0].icon
            } catch {
                print("JSON ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume();
    }
    
}
