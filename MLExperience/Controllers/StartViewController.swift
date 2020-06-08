//
//  StartViewController.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 07/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {
    
    @IBOutlet weak var comenzarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comenzarButton.layer.cornerRadius = 20
    }
    
    @IBAction func comenzarButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: LocalizedStrings.firstSegue, sender: self)
    }
    
}
