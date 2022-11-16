//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Илья Мишин on 24.09.2022.
//

import UIKit
import Kingfisher

class CryptoViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView(style: .medium)
        
    var search = UISearchController()
    
    static let titleColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.backgroundColor = titleColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
        
    var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.locale = .current
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.formatterBehavior = .default
        
        return numberFormatter
    }()
    
    var viewModels = [CryptoTableViewCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Type a crypto..."
        self.navigationItem.searchController = search
        
        configure()
        
        spinner.startAnimating()
        APICaller.shared.getAllCrytos { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let models):
                self.viewModels = models.map({ model in
                    let price = model.price_usd ?? 0
                    let formatter = self.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    let iconUrl = URL(string: APICaller.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                    }).first?.url ?? "")
                    return CryptoTableViewCellModel(name: model.name ?? "", symbol: model.asset_id ?? "", price: priceString ?? "", iconUrl: iconUrl)
                })
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CryptoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { fatalError() }

        var crypto: Crypto
        if isSearch() {
            crypto = APICaller.shared.cryptosFiltered[indexPath.row]
        } else {
            crypto = APICaller.shared.crypto[indexPath.row]
        }

        let price = crypto.price_usd ?? 0
        let formatter = self.numberFormatter
        let priceString = formatter.string(from: NSNumber(value: price))

        if isSearch() {
            cell.nameLabel.text = crypto.name
            cell.symbolLabel.text = crypto.asset_id
            cell.priceLabel.text = priceString
            let url = URL(string: APICaller.shared.icons.filter({ icon in
                icon.asset_id == crypto.asset_id
            }).first?.url ?? "")
            cell.iconImageView.kf.setImage(with: url, placeholder: UIImage(named: "unknowed"))
        } else {
            cell.configure(with: viewModels[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return APICaller.shared.cryptosFiltered.count
        }
        return APICaller.shared.crypto.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension CryptoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchCrypto(text: searchController.searchBar.text!)
    }
    
    func filterSearchCrypto(text: String) {
        APICaller.shared.filterCryptos(text: text)
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    func isSearch() -> Bool {
        return search.isActive && !searchBarIsEmpty()
    }
    
    func configure() {
        view.addSubview(spinner)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
            ])
                
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        title = "Crypto Tracker"
        navigationController?.navigationBar.barTintColor = CryptoViewController.titleColor
        navigationController?.view.backgroundColor = CryptoViewController.titleColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
    }
}
