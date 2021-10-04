//
//  ViewController.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/4/21.
//

import UIKit

class LocationListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addLocationBarButton: UIBarButtonItem!
    
    
    var weatherLocations: [WeatherLocation] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var weatherLocation = WeatherLocation.init(name: "Chestnut Hill, MA", latitide: 0, longitude: 0);
        weatherLocations.append(weatherLocation);
        weatherLocation = WeatherLocation.init(name: "New York City, NY", latitide: 0, longitude: 0);
        weatherLocations.append(weatherLocation);
        weatherLocation = WeatherLocation.init(name: "San Francisco, CA", latitide: 0, longitude: 0);
        weatherLocations.append(weatherLocation);
        
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    @IBAction func addLocationPressed(_ sender: UIBarButtonItem) {
        
        
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

