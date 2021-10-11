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
    @IBOutlet weak var pageControl: UIPageControl!
    
    var weatherDetail: WeatherDetail!;
    var locationIndex = 0;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserInterface();
        

        // Do any additional setup after loading the view.
    }
    
//    func loadLocations()
//    {
//        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations")
//                as? Data else{
//                    print("ERROR: Could not load weatherLocations data from UserDefaults. Unless this is the first time, else ignore")
//                    return
//                }
//
//        let decoder = JSONDecoder()
//        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation]{
//            self.weatherLocations = weatherLocations
//        } else{
//            print("ERROR: Couldn't decode data read from UserDefaults.")
//        }
//    }
    
    func updateUserInterface()
    {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        let weatherLocation = pageViewController.weatherLocations[locationIndex];
        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitide, longitude: weatherLocation.longitude)
        
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count;
        pageControl.currentPage = locationIndex
        
        weatherDetail.getData(){
            DispatchQueue.main.async {
                self.dateLabel.text = self.weatherDetail.timezone;
                self.placeLabel.text = self.weatherDetail.name;
                self.temperatureLabel.text = String(self.weatherDetail.temperature);
                self.summaryLabel.text = self.weatherDetail.summary;
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController

        destination.weatherLocations = pageViewController.weatherLocations;
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue){
        let source = segue.source as! LocationListViewController;
        locationIndex = source.selectedLocationIndex;
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController

        
        pageViewController.weatherLocations = source.weatherLocations;
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
        
        
    }
    
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        var direction: UIPageViewController.NavigationDirection = .forward;
        
        if sender.currentPage < locationIndex{
            direction = .reverse
        }
        
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)

        
    }
    


}
