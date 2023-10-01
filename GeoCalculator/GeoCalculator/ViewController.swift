//
//  ViewController.swift
//  GeoCalculator
//
//  Created by Corey on 9/26/23.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate, SettingsViewControllerDelegate {

    @IBOutlet weak var latitudep1Var: DecimalMinusTextField!
    @IBOutlet weak var longitudep1Var: DecimalMinusTextField!
    @IBOutlet weak var latitudep2Var: DecimalMinusTextField!
    @IBOutlet weak var longitudep2Var: DecimalMinusTextField!
    @IBOutlet weak var distanceOutputField: DecimalMinusTextField!
    @IBOutlet weak var bearingOutputField: DecimalMinusTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        self.bearingOutputField.delegate = self
        self.distanceOutputField.delegate = self
        self.longitudep1Var.delegate = self
        self.longitudep2Var.delegate = self
        self.latitudep1Var.delegate = self
        self.latitudep2Var.delegate = self

        
    }
    
    func indicateSelection(units: String) {
        showAlert(message: "This is supposed to show that we've made changes in settings.")
    }
    
    //missing data changing methods or functions. does not save choice from settings screen. 
    
    func validateInput(text: String) -> Double? {
        if let value = Double(text) {
            // Check if the value is within a valid range
            if value >= 0.0 {
                return value
            } else {
                return nil // Input is a number but out of range (e.g., negative)
            }
        } else {
            return nil // Input is not a valid number
        }
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        // Validate input from text boxes
        guard let lat1Text = latitudep1Var.text,
              let lon1Text = longitudep1Var.text,
              let lat2Text = latitudep2Var.text,
              let lon2Text = longitudep2Var.text,
              let lat1 = validateInput(text: lat1Text),
              let lon1 = validateInput(text: lon1Text),
              let lat2 = validateInput(text: lat2Text),
              let lon2 = validateInput(text: lon2Text) else {
                // Display an alert for invalid input
                showAlert(message: "Please enter valid numeric values in the text boxes.")
                return
        }

        // Handle valid input and perform calculations
        let location1 = Location(latitude: lat1, longitude: lon1)
        let location2 = Location(latitude: lat2, longitude: lon2)

        // Calculate distance and bearing
        let distance = calculateDistance(fromLocation: location1, toLocation: location2)
        let bearing = calculateBearing(fromLocation: location1, toLocation: location2)

        distanceOutputField.text = String(format: "%.2f kilometers", distance)
        bearingOutputField.text = String(format: "%.2f degrees", bearing)
    }
   
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        latitudep1Var.text = ""
        latitudep2Var.text = ""
        longitudep2Var.text = ""
        longitudep1Var.text = ""
        distanceOutputField.text = ""
        bearingOutputField.text = ""
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //functions for distance and bearing below.
    
    struct Location {
        var latitude: Double
        var longitude: Double
    }

    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }

    func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
    
    func calculateDistance(fromLocation location1: Location, toLocation location2: Location) -> Double {
        let earthRadius: Double = 6371 // Earth's radius in kilometers

        // Convert latitude and longitude from degrees to radians
        let lat1 = degreesToRadians(location1.latitude)
        let lon1 = degreesToRadians(location1.longitude)
        let lat2 = degreesToRadians(location2.latitude)
        let lon2 = degreesToRadians(location2.longitude)

        // Haversine formula for distance
        let dlon = lon2 - lon1
        let dlat = lat2 - lat1
        let a = sin(dlat/2) * sin(dlat/2) + cos(lat1) * cos(lat2) * sin(dlon/2) * sin(dlon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let distance = earthRadius * c

        return distance
    }
    
    func calculateDistanceInMiles(fromLocation location1: Location, toLocation location2: Location) -> Double {
        let earthRadiusMiles: Double = 3958.8 // Earth's radius in miles

        // Convert latitude and longitude from degrees to radians
        let lat1 = degreesToRadians(location1.latitude)
        let lon1 = degreesToRadians(location1.longitude)
        let lat2 = degreesToRadians(location2.latitude)
        let lon2 = degreesToRadians(location2.longitude)

        // Haversine formula for distance in miles
        let dlon = lon2 - lon1
        let dlat = lat2 - lat1
        let a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distanceMiles = earthRadiusMiles * c

        return distanceMiles
    }
    
    func calculateBearing(fromLocation location1: Location, toLocation location2: Location) -> Double {
        // Convert latitude and longitude from degrees to radians
        let lat1 = degreesToRadians(location1.latitude)
        let lon1 = degreesToRadians(location1.longitude)
        let lat2 = degreesToRadians(location2.latitude)
        let lon2 = degreesToRadians(location2.longitude)

        // Calculate initial bearing
        let y = sin(lon2 - lon1) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1)
        let bearing = atan2(y, x)

        // Convert bearing from radians to degrees
        let bearingDegrees = (radiansToDegrees(bearing) + 360).truncatingRemainder(dividingBy: 360)

        return bearingDegrees
    }
    
    func calculateBearingInMils(fromLocation location1: Location, toLocation location2: Location) -> Double {
        // Convert latitude and longitude from degrees to radians
        let lat1 = degreesToRadians(location1.latitude)
        let lon1 = degreesToRadians(location1.longitude)
        let lat2 = degreesToRadians(location2.latitude)
        let lon2 = degreesToRadians(location2.longitude)

        // Calculate initial bearing in radians
        let y = sin(lon2 - lon1) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1)
        let initialBearing = atan2(y, x)

        // Convert initial bearing from radians to degrees
        let initialBearingDegrees = radiansToDegrees(initialBearing)

        // Normalize bearing to the range [0, 360] degrees
        let bearingDegrees = (initialBearingDegrees + 360).truncatingRemainder(dividingBy: 360)

        // Convert bearing from degrees to mils (1 degree = 17.777777777778 mils)
        let bearingMils = bearingDegrees * 17.777777777778

        return bearingMils
    }

    class DecimalMinusTextField: UITextField {
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.keyboardType = UIKeyboardType.decimalPad

        }
        
        fileprivate func getAccessoryButtons() -> UIView
        {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.superview!.frame.size.width, height: 44))
            view.backgroundColor = UIColor.lightGray
            
            let minusButton = UIButton(type: UIButton.ButtonType.custom)
            let doneButton = UIButton(type: UIButton.ButtonType.custom)
            minusButton.setTitle("-", for: UIControl.State())
            doneButton.setTitle("Done", for: UIControl.State())
            let buttonWidth = view.frame.size.width/3;
            minusButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 44);
            doneButton.frame = CGRect(x: view.frame.size.width - buttonWidth, y: 0, width: buttonWidth, height: 44);
            
            minusButton.addTarget(self, action: #selector(DecimalMinusTextField.minusTouchUpInside(_:)), for: UIControl.Event.touchUpInside)
            doneButton.addTarget(self, action: #selector(DecimalMinusTextField.doneTouchUpInside(_:)), for: UIControl.Event.touchUpInside)
            
            view.addSubview(minusButton)
            view.addSubview(doneButton)
            
            return view;
        }
        
        @objc func minusTouchUpInside(_ sender: UIButton!) {

            let text = self.text!
            if(text.count > 0) {
                let index: String.Index = text.index(text.startIndex, offsetBy: 1)
                let firstChar = text[..<index]
                if firstChar == "-" {
                    self.text = String(text[index...])
                } else {
                    self.text = "-" + text
                }
            }
        }
        
        @objc func doneTouchUpInside(_ sender: UIButton!) {
            self.resignFirstResponder();
            
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.inputAccessoryView = getAccessoryButtons()
        }


    }
}
