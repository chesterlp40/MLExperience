//
//  DuesViewController.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 08/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import UIKit

class DuesViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var duesTextField: UITextField!
    @IBOutlet weak var siguienteButton: UIButton!
    
    let duesPickerView = UIPickerView()
    var restAPIClient = RestAPIClient()
    var messages: [PayerCosts] = []
    var amount = LocalizedStrings.emptyString
    var payMethodId = LocalizedStrings.emptyString
    var payMethodName = LocalizedStrings.emptyString
    var bankId = LocalizedStrings.emptyString
    var bankName = LocalizedStrings.emptyString

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        siguienteButton.layer.cornerRadius = 20
        restAPIClient.delegateDues = self
        duesPickerView.delegate = self
        duesPickerView.dataSource = self
        duesTextField.delegate = self
        DispatchQueue.main.async {
            self.restAPIClient.fetchDues(amount: self.amount, payMethodId: self.payMethodId, bankId: self.bankId)
        }
        duesTextField.inputView = duesPickerView
        duesTextField.addTarget(self, action: #selector(setDuesDefault), for: UIControl.Event.touchDown)
    }
    
    @objc func setDuesDefault() {
        if duesTextField.text == LocalizedStrings.emptyString {
            DispatchQueue.main.async {
                self.duesTextField.text = self.messages[0].payer_costs[0].recommended_message
            }
        }
    }
    
    @IBAction func siguienteButtonPressed(_ sender: UIButton) {
        
    }
    
}

//MARK: - UITextFieldDelegate Section

extension DuesViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        duesPickerView.reloadAllComponents()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        duesTextField.endEditing(true)
        return true
    }
    
}

//MARK: - UIPickerView Section

extension DuesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return messages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return messages[row].payer_costs[row].recommended_message
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        duesTextField.text = messages[row].payer_costs[row].recommended_message
    }
    
}

//MARK: - RestAPIClientDuesDelegate Section

extension DuesViewController: RestAPIClientDuesDelegate {
    
    func didSetDues(_ restAPIClient: RestAPIClient, messages: [PayerCosts]) {
        DispatchQueue.main.async {
            self.messages = messages
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
