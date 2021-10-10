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
        
        updateUserInterface();
        

        // Do any additional setup after loading the view.
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