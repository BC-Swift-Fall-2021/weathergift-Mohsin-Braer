//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/11/21.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

private let hourFormatter: DateFormatter = {
    let hourFormatter = DateFormatter()
    hourFormatter.dateFormat = "ha"
    return hourFormatter
}()

struct DailyWeather {
    var dailyIcon: String
    var dailyWeekday: String
    var dailyHigh: Int
    var dailyLow: Int

}

struct HourlyWeather{
    var hour: String
    var hourlyIcon: String
    var hourlyTemperature: Int
}

class WeatherDetail: WeatherLocation {
   
     private struct Result:  Codable{
        var timezone: String
        var current: Current
        var daily: [Daily]
        var hourly: [Hourly]
    }
    
     private struct Current: Codable{
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
     private struct Weather: Codable{
        var description: String
        var icon: String
    }
    
    private struct Daily: Codable{
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Hourly: Codable{
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []
    
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
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count{
                    let weekDayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekDayDate)
                    let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyMax = Int(result.daily[index].temp.max.rounded())
                    let dailyMin = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: "", dailyHigh: dailyMax, dailyLow: dailyMin)
                    self.dailyWeatherData.append(dailyWeather)
                    print("Day: \(dailyWeekday)  High: \(dailyMax)  Low: \(dailyMin)")

                }
                //get only 24 hrs of hourly data
                let lastHour = min(24, result.hourly.count)
                if lastHour > 0{
                    for index in 1...lastHour{
                        let hourlyDate = Date(timeIntervalSince1970: result.hourly[index].dt)
                        hourFormatter.timeZone = TimeZone(identifier: result.timezone)
                        let hour = hourFormatter.string(from: hourlyDate)
                        let hourlyIcon = self.fileNameForIcon(icon: result.hourly[index].weather[0].icon)
                        let hourlyTemperature = Int(result.hourly[index].temp.rounded())
                        let hourlyWeather = HourlyWeather(hour: hour, hourlyIcon: hourlyIcon, hourlyTemperature: hourlyTemperature)
                        self.hourlyWeatherData.append(hourlyWeather)
                        print("Hour: \(hour)  Temperature: \(hourlyTemperature)  Icon: \(hourlyIcon)")
                    }
                }
            
            } catch {
                print("JSON ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume();
    }
    
    func fileNameForIcon(icon: String) -> String{
        var newFileName = ""
        
        switch icon{
        case "01d":
            newFileName = "clear-day"
        case "01n":
            newFileName = "clear-night"
        case "02d":
            newFileName = "partly-cloudy-day"
        case "02n":
            newFileName = "partly-cloudy-night"
        case "03d", "03n", "04d", "04n":
            newFileName = "cloudy"
        case "09d", "09n", "10d", "10n":
            newFileName = "rain"
        case "11d", "11n":
            newFileName = "thunderstorm"
        case "13d", "13n":
            newFileName = "snow"
        case "50d", "50n":
            newFileName = "fog"
        default:
            newFileName = ""
        }
        
        return newFileName
    }
    
}
