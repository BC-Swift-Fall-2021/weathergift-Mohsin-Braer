//
//  LocationDetailViewController.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/10/21.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
   
    var weatherLocation: WeatherLocation!;
    var weatherLocations: [WeatherLocation] = [];
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if weatherLocation == nil{
            weatherLocation = WeatherLocation(name: "Current Location", latitide: 0, longitude: 0)
            weatherLocations.append(weatherLocation);
        }
        
        loadLocations();
        updateUserInterface();
        

        // Do any additional setup after loading the view.
    }
    
    func loadLocations()
    {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations")
                as? Data else{
                    print("ERROR: Could not load weatherLocations data from UserDefaults. Unless this is the first time, else ignore")
                    return
                }
        
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation]{
            self.weatherLocations = weatherLocations
        } else{
            print("ERROR: Couldn't decode data read from UserDefaults.")
        }
    }
    
    func updateUserInterface()
    {
        dateLabel.text = "";
        placeLabel.text = weatherLocation.name;
        temperatureLabel.text = "--°"
        summaryLabel.text = "";
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.weatherLocations = weatherLocations;
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue){
        let source = segue.source as! LocationListViewController;
        weatherLocations = source.weatherLocations;
        weatherLocation = weatherLocations[source.selectedLocationIndex]
        updateUserInterface();
        
        
        
    }
    


}
