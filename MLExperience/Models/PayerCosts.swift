//
//  PayerCosts.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 08/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import Foundation

struct PayerCosts: Decodable {
    let payer_costs: [Messages]
}

struct Messages: Decodable {
    let recommended_message: String
}
