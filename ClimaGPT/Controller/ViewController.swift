//
//  ViewController.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 06/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var UserInputTextField: UITextField!
    var weatherManager = WeatherManager()

    @IBAction func SendCityButton(_ sender: UIButton) {
        let userCity = UserInputTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        weatherManager.fetchWeatherWithCityName(cityName: "Monterrey")
        
        
        
    }


}

extension ViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.cityName)
        print(weather.temperatureString)
        print(weather.conditionName)
    }
    
}

