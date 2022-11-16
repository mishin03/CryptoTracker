//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Илья Мишин on 24.09.2022.
//

import UIKit

class APICaller {
    
    static let shared = APICaller()
    
    init() {}
    
    var icons = [Icon]()
    
    var cryptosFiltered = [Crypto]()
    
    var crypto = [Crypto]()
    
    func filterCryptos(text: String) {
        cryptosFiltered.removeAll()
        
        cryptosFiltered = crypto.filter({ (crypto) -> Bool in
            return crypto.name!.lowercased().contains(text.lowercased())
        })
    }
    
    var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    func getAllCrytos(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        if !icons.isEmpty {
            whenReadyBlock = completion
        }
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/?apikey=71A66DD3-F7F0-464E-B15E-54EC3263297C") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos.filter({ crypto in
                    crypto.id_icon != nil
                })))
                self.crypto = cryptos
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=71A66DD3-F7F0-464E-B15E-54EC3263297C") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                self.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self.whenReadyBlock {
                    self.getAllCrytos(completion: completion)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
