//
//  ViewController.swift
//  ClimaGPT
//
//  Created by Santiago Aguirre on 06/02/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    var weatherManager = WeatherManager()   // WeatherManager object to access and trigger the weather fetching functions
    
    var weatherCells : [WeatherModel] = []
    
    var cellCounter : Int = 0 // Created to display 1 cell at a time, not 2 cells at the same time
    var weatherDisplayArrayPosition : Int = 0 // Created to not use cellCounter as the position of weather object to be fetched (index out of range on 2nd call)
        
    var isError : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserInputTextField: UITextField!
    @IBOutlet weak var searchInputView: UIView!
    @IBOutlet weak var initialView: UIView!
    
    @IBOutlet weak var exampleBoxOne: UIView!
    @IBOutlet weak var exampleBoxTwo: UIView!
    @IBOutlet weak var exampleBoxThree: UIView!
    
    // MARK: ----- User Send Button Pressed -----
    
    @IBAction func SendCityButton(_ sender: UIButton) { // ===== 1. User clicks send to get the weather data =====
        
        initialView.isHidden = true
        
        if let cityRequest = UserInputTextField.text?.capitalized, !cityRequest.isEmpty {
            
            self.weatherCells.append(WeatherModel(cityName: cityRequest, temperature: 0.00, conditionID: 0, isError: false))
            cellCounter += 1

            // Display 2 cells
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
            weatherManager.fetchWeatherWithCityName(cityName: cityRequest)
            UserInputTextField.text = ""
            dismissKeyboard()
            
        }
        
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialView.isHidden = false
        
        searchInputView.layer.cornerRadius = 4
        
        exampleBoxOne.layer.cornerRadius = 5
        exampleBoxTwo.layer.cornerRadius = 5
        exampleBoxThree.layer.cornerRadius = 5
        
        searchInputView.layer.shadowColor = UIColor.black.cgColor
        searchInputView.layer.shadowOpacity = 0.15
        searchInputView.layer.shadowOffset = .zero
        searchInputView.layer.shadowRadius = 8
        
        weatherManager.delegate     = self
        tableView.dataSource        = self // Before running the delegate methods, the table view looks for which view is the responsible one for the data
        tableView.delegate          = self
        UserInputTextField.delegate = self
        
        // Screen Tap observer
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Assign XIB cell to the VC's table view (self.tableView)
        self.tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "ReusableWeatherCell")
        self.tableView.register(UINib(nibName: "ErrorCell", bundle: nil), forCellReuseIdentifier: "ReusableErrorCell")
        
        // Observers created to listen to keyboard pop-up and dismissal
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
    }

}

// MARK: - WeatherManager Protocol: where we receive the weather

extension ViewController : WeatherManagerDelegate {
    
    // ===== Error handling: No city was typed in UserInput =====
    func errorInWeatherFetch() {

        isError = true
        
        print("WeatherCells = \(weatherCells)")
        print("weatherDisplayArrayPosition = \(weatherDisplayArrayPosition)")
        
        weatherCells[weatherDisplayArrayPosition].isError = true
        
        cellCounter += 1
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        weatherDisplayArrayPosition += 1
        
    }

    // ===== 3. We (the VC) are notified that the WeatherData is received =====
    func didUpdateWeather(weather: WeatherModel) { // This is triggered by the WeatherManager when it finishes fetching the Weather Data
        
        weatherCells[weatherDisplayArrayPosition].temperature = weather.temperature
        weatherCells[weatherDisplayArrayPosition].conditionID = weather.conditionID
        
        print("Received the weather in the VC!")
        
        cellCounter += 1
        
        // Display 2 cells
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        weatherDisplayArrayPosition += 1
        
    }
    
}

// MARK: - UITableViewDataSource Protocol: responsible for populating the table view

extension ViewController : UITableViewDataSource, UITabBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // “How many rows or cells should I display in your tableView?”
        // Return 2 cells for each Weather fetch: the User input and the weather API answer
        return cellCounter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // “The current index is ___. What cell should I return? What design and data should the cell have?”
        
        let weatherCell = tableView.dequeueReusableCell(withIdentifier: "ReusableWeatherCell", for: indexPath) as! WeatherCell
        let errorCell = tableView.dequeueReusableCell(withIdentifier: "ReusableErrorCell", for: indexPath) as! ErrorCell
        
        // The position of the answer in the weatherCells array according to the index path
        let userInputWeatherPosition = indexPath.row / 2   // Ex: If row index = 2, Weather to fetch is in position 1 of array, so 2 / 2 = 1
                                                           // Ex: If row index = 5, Weather to fetch is in position 2 of array, so 5 / 2 = 2 (Swift round's the answers)("an Int divided by another is always an Int")
                                                           // Swift console answers: 5 / 2 = 2 ----- 7 / 2 = 3 ----- 9 / 2 = 4
        
        if weatherCells.count == 0 { // Error handling to avoid fetching value when array is empty
            return weatherCell
            
        } else {
            
            if indexPath.row % 2 == 0 { // Return User Input in a cell
                // User Input cell correct properties
                weatherCell.backgroundColor              = UIColor(named: "UserCell")
                weatherCell.internalView.backgroundColor = UIColor(named: "UserCell")
                weatherCell.cellIcon.image               = UIImage(named: "UserIcon")
                weatherCell.weatherCellText.text         = "What's the weather in \(weatherCells[userInputWeatherPosition].cityName)?"
                weatherCell.bottomLine.isHidden = false
            } else {  // Return Weather API fetch as a cell
                // If the cell is an error
                if weatherCells[userInputWeatherPosition].isError == true {
                    errorCell.bottomLine.isHidden          = true
                    return errorCell
                } else {
                    // Answer cell correct properties
                    weatherCell.backgroundColor              = UIColor(named: "AnswerCell")
                    weatherCell.internalView.backgroundColor = UIColor(named: "AnswerCell")
                    weatherCell.cellIcon.image               = UIImage(named: "ResponseImage")
                    weatherCell.weatherCellText.text         = "The current weather in \(weatherCells[userInputWeatherPosition].cityName) is \(weatherCells[userInputWeatherPosition].temperatureString) °C \(weatherCells[userInputWeatherPosition].conditionName)"
                    weatherCell.bottomLine.isHidden          = true
                }
                
            }
        }
        
        return weatherCell
        
    }
    
}

// MARK: - UITextFieldDelegate : Keyboard dismissal on return button

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UserInputTextField.endEditing(true)
        initialView.isHidden = true
        
        if textField.text != "" {
            if let cityRequest = UserInputTextField.text?.capitalized, !cityRequest.isEmpty {
                
                self.weatherCells.append(WeatherModel(cityName: cityRequest, temperature: 0.00, conditionID: 0, isError: false))
                cellCounter += 1

                // Display 2 cells
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            
                weatherManager.fetchWeatherWithCityName(cityName: cityRequest)
                UserInputTextField.text = ""
                dismissKeyboard()
                
                tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
                
            }
        } else {
            textField.placeholder = "City Name"
        }
        
        return true
        
    }
    
}

// MARK: - Keyboard Pop-Up and Dismissal View Response Function

extension ViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Function to dismiss keyboard on screen tap
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
