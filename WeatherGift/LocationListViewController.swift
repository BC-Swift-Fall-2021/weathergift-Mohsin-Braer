//
//  ViewController.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/4/21.
//

import UIKit
import GooglePlaces

class LocationListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addLocationBarButton: UIBarButtonItem!
    
    
    var weatherLocations: [WeatherLocation] = [];
    
    var selectedLocationIndex = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
    }
    
    func saveLocations(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations)
        {
            UserDefaults.standard.set(encoded, forKey: "weatherLocations")
        } else{
            print("ERROR: Saving encoded did not work!")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row;
        saveLocations()
    }
    
    
    @IBAction func addLocationPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self

//           // Specify the place data types to return.
//           let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//             UInt(GMSPlaceField.placeID.rawValue))!
//           autocompleteController.placeFields = fields
//
//           // Specify a filter.
//           let filter = GMSAutocompleteFilter()
//           filter.type = .address
//           autocompleteController.autocompleteFilter = filter

           // Display the autocomplete view controller.
           present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            editBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            editBarButton.isEnabled = false
        }
        
    }
    
}


extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = "Lat:\(weatherLocations[indexPath.row].latitide) , Long:\(weatherLocations[indexPath.row].longitude)";
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            weatherLocations.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row];
        weatherLocations.remove(at: sourceIndexPath.row);
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row);
        
    }
    
    
}

extension LocationListViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
      let newLocation = WeatherLocation(name: place.name ?? "unkown place", latitide: place.coordinate.latitude, longitude: place.coordinate.longitude);
      
      weatherLocations.append(newLocation);
      tableView.reloadData();
      
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

//  // Turn the network activity indicator on and off again.
//  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//  }
//
//  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//  }

}

