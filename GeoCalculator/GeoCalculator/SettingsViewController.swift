//
//  SettingsViewController.swift
//  GeoCalculator
//
//  Created by Corey on 9/30/23.
//

import UIKit

protocol SettingsViewControllerDelegate{
    func indicateSelection(units: String)
}

class SettingsViewController: UIViewController {
    var pickerData: [String] = [String]()
    var selection: String = "Metric"
    var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var Units: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.pickerData = ["Metric", "Imperial"]
        Units.delegate = self
        Units.dataSource = self
        
        if let index = pickerData.firstIndex(of: self.selection){
            self.Units.selectRow(index, inComponent: 0, animated: true)
        }else{
            self.Units.selectRow(0, inComponent: 0, animated: true)
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        if let d = self.delegate {
            d.indicateSelection(units: selection)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selection = self.pickerData[row]
    }
}
