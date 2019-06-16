//
//  ViewController.swift
//  Weather
//
//  Created by Vinoth Varatharajan on 13/06/2019.
//  Copyright © 2019 Vin. All rights reserved.
//

import Foundation
import UIKit
import DropDown

enum CityEnum: String, CaseIterable {
    case sydney = "Sydney"
    case melbourne = "Melbourne"
    case wollongong = "Wollongong"
}

class ViewController: UIViewController {

    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    lazy var viewModel : WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Dropdown
    func allCityString() -> [String] {
        var cities : [String] = []
        for item in CityEnum.allCases {
            cities.append(item.rawValue)
        }
        return cities
    }
    
    func showDropDown(sender : UIButton) {
        
        let dropdown = DropDown()
        dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        
        dropdown.dataSource = allCityString()
        
        // Action triggered on selection
        dropdown.selectionAction = {(index: Int, item: String) in
            self.viewModel.city = item
        }
        
        // Will set a custom width instead of the anchor view width
        dropdown.width = sender.frame.width
        dropdown.show()
    }
    
    func updateUI(cityWeather : City) {
        cityLabel.text = cityWeather.name
        weatherLabel.text = cityWeather.weather.first?.weatherDescription
        tempratureLabel.text = cityWeather.main.tempInCelcius()
        windLabel.text = "\(cityWeather.wind.speed)"
        timeLabel.text = cityWeather.date
    }

    //MARK:- Button Actions
    
    @IBAction func selectCityAction(_ sender: UIButton) {
        showDropDown(sender: sender)
    }
    
    //MARK:- UIAlertView
    
    func displayErrorAlert() {
        
        let actionSheet: UIAlertController = UIAlertController(title: "No data", message: "Per day request may expired.", preferredStyle: .alert)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        actionSheet.addAction(cancelActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }

}

extension ViewController : WeatherInfoDelegate {
   
    func weatherInfoFetchSuccessful(city: City?) {
        guard let city_ = city else {
            self .displayErrorAlert()
            return}
        updateUI(cityWeather: city_)
    }
}
