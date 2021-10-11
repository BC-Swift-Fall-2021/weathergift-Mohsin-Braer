//
//  PageViewController.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/11/21.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var weatherLocations: [WeatherLocation] = [];

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self;
        self.dataSource = self;
        
        loadLocations();
        
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil);
    }
    
    func loadLocations()
    {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations")
                as? Data else{
                    print("ERROR: Could not load weatherLocations data from UserDefaults. Unless this is the first time, else ignore")
                    weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))
                    return
                }
        
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation]{
            self.weatherLocations = weatherLocations
        } else{
            print("ERROR: Couldn't decode data read from UserDefaults.")
        }
        
        if weatherLocations.isEmpty{
            weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))

        }
        
    }
    
    func createLocationDetailViewController(forPage page: Int) -> LocationDetailViewController {
        let detailViewController = storyboard!.instantiateViewController(withIdentifier: "LocationDetailViewController") as! LocationDetailViewController
        
        detailViewController.locationIndex = page;
        return detailViewController;
        
    }


}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController{
            if currentViewController.locationIndex > 0{
                return createLocationDetailViewController(forPage: currentViewController.locationIndex-1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count-1 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex+1)
            }
        }
        return nil
        
    }
    
    
}
