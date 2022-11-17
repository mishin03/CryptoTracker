//
//  CryptoTableViewCell.swift
//  CryptoTracker
//
//  Created by Илья Мишин on 24.09.2022.
//

import UIKit
import Kingfisher

class CryptoTableViewCellModel {
    let name: String
    let symbol: String
    let price: String
    var iconUrl: URL?
    var iconData: Data?
    
    init(name: String, symbol: String, price: String, iconUrl: URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}

class CryptoTableViewCell: UITableViewCell {

    static let identifier = "CryptoTableViewCell"
    
//    subviews
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
//    init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    layout
    
    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 95),

            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 95),

            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        let size: CGFloat = contentView.frame.size.height/1.1
        iconImageView.frame = CGRect(x: 20,
                                 y: (contentView.frame.size.height-size)/2,
                                 width: size,
                                 height: size)
    }
    
//    configure
    
    func configure(with viewModel: CryptoTableViewCellModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        iconImageView.kf.setImage(with: viewModel.iconUrl, placeholder: UIImage(named: "unknowed"))
    }
}
