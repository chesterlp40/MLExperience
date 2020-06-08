//
//  BankSelectorViewController.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 07/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import UIKit

class BankSelectorViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bankTextField: UITextField!
    @IBOutlet weak var siguienteButton: UIButton!
    
    let banksPickerView = UIPickerView()
    var restAPIClient = RestAPIClient()
    var banks: [Banks] = []
    var amount = LocalizedStrings.emptyString
    var payMethodId = LocalizedStrings.emptyString
    var payMethodName = LocalizedStrings.emptyString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        siguienteButton.layer.cornerRadius = 20
        restAPIClient.delegateBanks = self
        banksPickerView.delegate = self
        banksPickerView.dataSource = self
        bankTextField.delegate = self
        DispatchQueue.main.async {
            self.restAPIClient.fetchBanks(payMethodId: self.payMethodId)
            /*if self.banks.count == 0 {
                let alert = UIAlertController(title: LocalizedStrings.sorry, message: LocalizedStrings.noBanks, preferredStyle: .alert)
                let aceptar = UIAlertAction(title: LocalizedStrings.ok, style: .default, handler: { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)})
                alert.addAction(aceptar)
                self.present(alert, animated: true, completion: nil)
            }*/
        }
        bankTextField.inputView = banksPickerView
        bankTextField.addTarget(self, action: #selector(setBankDefault), for: UIControl.Event.touchDown)
    }
    
    @objc func setBankDefault() {
        if bankTextField.text == LocalizedStrings.emptyString {
            DispatchQueue.main.async {
                self.bankTextField.text = self.banks[0].name
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var bankId = LocalizedStrings.emptyString
        if bankTextField.text != LocalizedStrings.emptyString {
            if segue.identifier == LocalizedStrings.fourthSegue {
                for bank in banks {
                    if bank.name == bankTextField.text {
                        bankId = bank.id
                    }
                }
                let destinationVC = segue.destination as! DuesViewController
                destinationVC.amount = amount
                destinationVC.payMethodId = payMethodId
                destinationVC.payMethodName = payMethodName
                destinationVC.bankId = bankId
                destinationVC.bankName = bankTextField.text!
            }
        }
    }

    @IBAction func siguienteButtonPressed(_ sender: UIButton) {
        if bankTextField.text != LocalizedStrings.emptyString {
            performSegue(withIdentifier: LocalizedStrings.fourthSegue, sender: self)
        } else {
            let alert = UIAlertController(title: LocalizedStrings.ups, message: LocalizedStrings.withoutDues, preferredStyle: .alert)
            let aceptar = UIAlertAction(title: LocalizedStrings.ok, style: .default, handler: nil)
            alert.addAction(aceptar)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate Section

extension BankSelectorViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        banksPickerView.reloadAllComponents()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bankTextField.endEditing(true)
        return true
    }
    
}

//MARK: - UIPickerView Section

extension BankSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return banks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return banks[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bankTextField.text = banks[row].name
    }
    
}

//MARK: - RestAPIClientBanksDelegate Section

extension BankSelectorViewController: RestAPIClientBanksDelegate {
    
    func didSetBanks(_ restAPIClient: RestAPIClient, banks: [Banks]) {
        DispatchQueue.main.async {
            self.banks = banks
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
