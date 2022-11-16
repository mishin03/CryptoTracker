//
//  APIModels.swift
//  CryptoTracker
//
//  Created by Илья Мишин on 24.09.2022.
//

import UIKit

class Crypto: Codable {
    let asset_id: String?
    let name: String?
    let price_usd: Float?
    let id_icon: String?
    var iconUrl: URL?
}

class Icon: Codable {
    let asset_id: String?
    let url: String?
}
