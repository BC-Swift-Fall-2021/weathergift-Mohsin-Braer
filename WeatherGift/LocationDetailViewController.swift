//
//  LocationDetailViewController.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/10/21.
//

import UIKit
import CoreLocation


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM, d"
    return dateFormatter
}()

class LocationDetailViewController: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var weatherDetail: WeatherDetail!;
    var locationIndex = 0;
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearUserInterface()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if locationIndex == 0{
            getLocation()
        }
        
        updateUserInterface();
        
    }
    
    
    func clearUserInterface()
    {
        dateLabel.text = ""
        placeLabel.text = ""
        temperatureLabel.text = ""
        summaryLabel.text = ""
        
        imageView.image = UIImage()

    }

    
    func updateUserInterface()
    {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        let weatherLocation = pageViewController.weatherLocations[locationIndex];
        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitide, longitude: weatherLocation.longitude)
        
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count;
        pageControl.currentPage = locationIndex
        
        weatherDetail.getData(){
            DispatchQueue.main.async {
                dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezone)
                let usableDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                self.dateLabel.text = dateFormatter.string(from: usableDate)
                self.placeLabel.text = self.weatherDetail.name;
                self.temperatureLabel.text = String(self.weatherDetail.temperature);
                self.summaryLabel.text = self.weatherDetail.summary;
                
                self.imageView.image = UIImage(named: self.weatherDetail.dayIcon)
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowList" {
            let destination = segue.destination as! LocationListViewController
            let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController

            destination.weatherLocations = pageViewController.weatherLocations;
        }
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

}

extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetail.dailyWeatherData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyTableViewCell
        cell.dailyWeather = weatherDetail.dailyWeatherData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
   
    
    
    
}

extension LocationDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDetail.hourlyWeatherData.count
    }
    
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCollectionViewCell
    hourlyCell.hourlyWeather = weatherDetail.hourlyWeatherData[indexPath.row]
    return hourlyCell
}
    
}

extension LocationDetailViewController: CLLocationManagerDelegate{
    
    func getLocation(){
        //Will automatically check authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthenticationStatus(status: status)
    }
    
    func handleAuthenticationStatus(status: CLAuthorizationStatus){
        switch status{
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "Parental controls may be restricting location use")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select settigns below")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEVELOPER ALERT: Unknown case of status in handleAuthenticationStatus\(status)")
        }
        
    }
    
    func showAlertToPrivacySettings(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else{
            print("Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating location")
        let currentLocation = locations.last ?? CLLocation()
        print("Current Location: (\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            var locationName = ""
            if placemarks != nil{
                let placemark = placemarks?.last
                locationName = placemark?.name ?? "Parts Unknown"
            } else{
                print("ERROR retrieving place. Error code: \(error?.localizedDescription)")
                locationName = "Could not find location"
            }
            print("locationName = \(locationName)")
            
            let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            pageViewController.weatherLocations[self.locationIndex].latitide = currentLocation.coordinate.latitude
            pageViewController.weatherLocations[self.locationIndex].longitude = currentLocation.coordinate.longitude
           
            self.updateUserInterface()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: Could not get location (didFailWithError)")
    }
}

