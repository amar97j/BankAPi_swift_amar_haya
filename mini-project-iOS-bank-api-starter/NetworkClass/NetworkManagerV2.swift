//
//  NetworkManagerV2.swift
//  mini-project-iOS-bank-api-starter
//
//  Created by Amora J. F. on 07/03/2024.
//

import Foundation
import Alamofire


class NetworkManager2 {
    
    private let baseUrl = "https://coded-bank-api.eapi.joincoded.com/"
    
    static let shared = NetworkManager2()
    
    func signup(user: User, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        let url = baseUrl + "signup"
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).responseDecodable(of: TokenResponse.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let afError):
                completion(.failure(afError as Error))
            }
        }
    }
    
    
    func getTransactions(token: String, completion: @escaping (Result<[Transaction], Error>) -> Void) {
                    let url = baseUrl + "transactions"
                    let headers: HTTPHeaders = [.authorization(bearerToken: token)]

            AF.request(url, method:.get,headers: headers).responseDecodable(of: [Transaction].self) { response in
                        switch response.result {
                        case .success(let transactions):
                            completion(.success (transactions))
                        case .failure(let error):
                            completion(.failure (error))
                        }
                    }

                }
    
}


/*
 NetworkManager2.shared.getTransactions(token: self.token!) { result in

             DispatchQueue.main.async {
                 switch result {
                 case .success(let transactions):
                     print("Transactions received: (transactions)")
                     for transaction in transactions {
                         print(transaction.receiverId)
                     }
 //                    self.transactions = transactions
 //                                self.tableView.reloadData()
                 case .failure(let error):
                     print("Failed to fetch transactions: (error)")
                 }
             }

         }
 */
