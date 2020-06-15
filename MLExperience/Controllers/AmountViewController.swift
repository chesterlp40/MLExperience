//
//  AmountViewController.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 07/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import UIKit

class AmountViewController: BaseViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var siguienteButton: UIButton!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        siguienteButton.layer.cornerRadius = 20
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if amountTextField.text != LocalizedStrings.emptyString {
            if segue.identifier == LocalizedStrings.secondSegue {
                let destinationVC = segue.destination as! PayMethodViewController
                let string$ = amountTextField.text!.dropFirst()
                let newAmount = string$.replacingOccurrences(of: ",", with: "")
                destinationVC.amount = newAmount
            }
        }
    }
    
    @IBAction func siguienteButtonPressed(_ sender: UIButton) {
        if amountTextField.text != LocalizedStrings.emptyString {
            performSegue(withIdentifier: LocalizedStrings.secondSegue, sender: self)
        } else {
            let alert = UIAlertController(title: LocalizedStrings.ups, message: LocalizedStrings.withoutAmount, preferredStyle: .alert)
            let aceptar = UIAlertAction(title: LocalizedStrings.ok, style: .default, handler: nil)
            alert.addAction(aceptar)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

//MARK: - UITextFieldDelegate Section

extension AmountViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 10 {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight > CGFloat(screenHeightConstant) {
            buttonConstraint.constant = 290
        } else {
            buttonConstraint.constant = 230
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        buttonConstraint.constant = CGFloat(baseButtonHeight)
        return true
    }
    
}
