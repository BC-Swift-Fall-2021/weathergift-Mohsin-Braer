//
//  DailyTableViewCell.swift
//  WeatherGift
//
//  Created by Mohsin Braer on 10/25/21.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dailyWeekdayLabel: UILabel!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyHighLabel: UILabel!
    @IBOutlet weak var dailyLowLabel: UILabel!
    @IBOutlet weak var dailySummaryLabel: UITextView!
    
    var dailyWeather: DailyWeather! {
        didSet{
            dailyImageView.image = UIImage(named: dailyWeather.dailyIcon)
            dailyWeekdayLabel.text = dailyWeather.dailyWeekday
            dailyHighLabel.text = "\(dailyWeather.dailyHigh)"
            dailyLowLabel.text = "\(dailyWeather.dailyLow)"
            dailySummaryLabel.text = dailyWeather.dailySummary
            
        }
    }
    
    
}
