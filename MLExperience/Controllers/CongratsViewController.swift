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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        finalizarButton.layer.cornerRadius = CGFloat(cornerRadiusValue)
    }

    @IBAction func finalizarButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
