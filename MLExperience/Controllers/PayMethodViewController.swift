//
//  PayMethodViewController.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 07/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import UIKit

class PayMethodViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var payMethodTextField: UITextField!
    @IBOutlet weak var siguienteButton: UIButton!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    
    let creditCardsPickerView = UIPickerView()
    var amount = LocalizedStrings.emptyString
    var restAPIClient = RestAPIClient()
    var creditCards: [CreditCards] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        siguienteButton.layer.cornerRadius = CGFloat(cornerRadiusValue)
        restAPIClient.delegateCreditCards = self
        creditCardsPickerView.delegate = self
        creditCardsPickerView.dataSource = self
        payMethodTextField.delegate = self
        DispatchQueue.main.async {
            self.restAPIClient.fetchPayMethod()
        }
        payMethodTextField.inputView = creditCardsPickerView
        payMethodTextField.addTarget(self,
                                     action: #selector(setCreditCardDefault),
                                     for: UIControl.Event.touchDown)
    }
    
    @objc func setCreditCardDefault() {
        if payMethodTextField.text == LocalizedStrings.emptyString {
            DispatchQueue.main.async {
                if self.creditCards.count != 0 {
                    self.payMethodTextField.text = self.creditCards[0].name
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        var payMethodId = LocalizedStrings.emptyString
        if payMethodTextField.text != LocalizedStrings.emptyString {
            if segue.identifier == LocalizedStrings.thirdSegue {
                for card in creditCards {
                    if card.name == payMethodTextField.text {
                        payMethodId = card.id
                    }
                }
                let destinationVC = segue.destination as! BankSelectorViewController
                destinationVC.amount = amount
                destinationVC.payMethodId = payMethodId
                destinationVC.payMethodName = payMethodTextField.text!
            }
        }
    }
    
    @IBAction func siguienteButtonPressed(_ sender: UIButton) {
        if payMethodTextField.text != LocalizedStrings.emptyString {
            performSegue(withIdentifier: LocalizedStrings.thirdSegue,
                         sender: self)
        } else {
            let alert = UIAlertController(title: LocalizedStrings.ups,
                                          message: LocalizedStrings.withoutCard,
                                          preferredStyle: .alert)
            let aceptar = UIAlertAction(title: LocalizedStrings.ok,
                                        style: .default,
                                        handler: nil)
            alert.addAction(aceptar)
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
    
}

//MARK: - UITextFieldDelegate Section

extension PayMethodViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        creditCardsPickerView.reloadAllComponents()
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight > CGFloat(screenHeightConstant) {
            buttonConstraint.constant = 200
        } else {
            buttonConstraint.constant = 230
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        buttonConstraint.constant = CGFloat(baseButtonHeight)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        payMethodTextField.endEditing(true)
        return true
    }
    
}

//MARK: - UIPickerView Section

extension PayMethodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return creditCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return creditCards[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        payMethodTextField.text = creditCards[row].name
    }
    
}

//MARK: - RestAPIClientDelegate Section

extension PayMethodViewController: RestAPIClientCreditCardsDelegate {
    
    func didSetCreditCrads(_ restAPIClient: RestAPIClient,
                           payMethod: [CreditCards]) {
        DispatchQueue.main.async {
            self.creditCards = payMethod
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
