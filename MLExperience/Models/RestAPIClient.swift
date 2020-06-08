//
//  RestAPIClient.swift
//  MLExperience
//
//  Created by Ezequiel Rasgido on 07/06/2020.
//  Copyright © 2020 Ezequiel Rasgido. All rights reserved.
//

import Foundation

protocol RestAPIClientCreditCardsDelegate {
    func didSetCreditCrads(_ restAPIClient: RestAPIClient, payMethod: [CreditCards])
    func didFailWithError(error: Error)
}

protocol RestAPIClientBanksDelegate {
    func didSetBanks(_ restAPIClient: RestAPIClient, banks: [Banks])
    func didFailWithError(error: Error)
}

protocol RestAPIClientDuesDelegate {
    func didSetDues(_ restAPIClient: RestAPIClient, messages: [PayerCosts])
    func didFailWithError(error: Error)
}

struct RestAPIClient {
    let publicKey = "444a9ef5-8a6b-429f-abdf-587639155d88"
    let baseUrl = "https://api.mercadopago.com/v1/payment_methods"
    var delegateCreditCards: RestAPIClientCreditCardsDelegate?
    var delegateBanks: RestAPIClientBanksDelegate?
    var delegateDues: RestAPIClientDuesDelegate?
    
    //MARK: - PayMethod Section
    
    func fetchPayMethod() {
        let urlPayMethod = "\(baseUrl)?public_key=\(publicKey)"
        performPayMethodRequest(url: urlPayMethod)
    }
    
    func performPayMethodRequest(url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let payMethod = self.parsePayMethodJSON(data: safeData) {
                        self.delegateCreditCards?.didSetCreditCrads(self, payMethod: payMethod)
                    }
                }
            }
            task.resume()
        }
    }

    func parsePayMethodJSON(data: Data) -> [CreditCards]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CreditCards].self, from: data)
            return decodedData
        } catch {
           delegateCreditCards?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - Banks Section
    
    func fetchBanks(payMethodId: String) {
        let urlBanks = "\(baseUrl)/card_issuers?public_key=\(publicKey)&payment_method_id=\(payMethodId)"
        performBanksRequest(url: urlBanks)
    }
    
    func performBanksRequest(url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let banks = self.parseBanksJSON(data: safeData) {
                        self.delegateBanks?.didSetBanks(self, banks: banks)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseBanksJSON(data: Data) -> [Banks]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Banks].self, from: data)
            return decodedData
        } catch {
           delegateBanks?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - Dues Section
    
    func fetchDues(amount: String, payMethodId: String, bankId: String) {
        let urlDues = "\(baseUrl)/installments?public_key=\(publicKey)&amount=12400.50&payment_method_id=\(payMethodId)&issuer.id=\(bankId)"
        performDuesRequest(url: urlDues)
    }
    
    func performDuesRequest(url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let messages = self.parseDuesJSON(data: safeData) {
                        self.delegateDues?.didSetDues(self, messages: messages)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseDuesJSON(data: Data) -> [PayerCosts]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([PayerCosts].self, from: data)
            return decodedData
        } catch {
           delegateDues?.didFailWithError(error: error)
            return nil
        }
    }
    
}
