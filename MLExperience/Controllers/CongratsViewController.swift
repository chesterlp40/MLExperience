//
//  CongratsViewController.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 15/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import UIKit

class CongratsViewController: BaseViewController {
    
    @IBOutlet weak var finalizarButton: UIButton!
    @IBOutlet weak var descriptPay: UILabel!
    
    var amount = LocalizedStrings.emptyString
    var payMethodName = LocalizedStrings.emptyString
    var bankName = LocalizedStrings.emptyString
    var dues = LocalizedStrings.emptyString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        finalizarButton.layer.cornerRadius = CGFloat(cornerRadiusValue)
        
        descriptPay.text = """
                            Monto:  $ \(amount)
                            Metodo de pago:  \(payMethodName)
                            Banco:  \(bankName)
                            Cuotas:  \(dues)
                            """
    }

    @IBAction func finalizarButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
