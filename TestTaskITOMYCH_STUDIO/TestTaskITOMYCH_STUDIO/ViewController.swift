//
//  ViewController.swift
//  TestTaskITOMYCH_STUDIO
//
//  Created by Pro on 27.11.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var currencies = [Currency]()
    private var justDollarAndEuro = [Currency]()
    private let urlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
    private var tableView = UITableView()
    private var converterButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Customize view
        self.view.backgroundColor = .white
        self.title = "Currencies"
        
        //MARK: - Get data form URL
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showErrowMessage()
            }
        } else {
            showErrowMessage()
        }
        
        //MARK: - Select the required elements from the currencies array
        for item in currencies {
            if (item.cc == "USD") || (item.cc == "EUR") {
                justDollarAndEuro.append(item)
            }
        }
        
        //MARK: - Adding subviews
        createTableView()
        createButton()
    }
    
    //MARK: - showErrorMessage
    private func showErrowMessage() {
        let ac = UIAlertController(title: "Error", message: "Data loading error!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    //MARK: - Create Button
    private func createButton() {
        converterButton = UIButton(frame: CGRect(x: 0, y: self.view.bounds.height - 75, width: self.view.bounds.width, height: 50))
        converterButton.setTitle("Converter", for: .normal)
        converterButton.setTitleColor(.black, for: .normal)
        converterButton.setTitleColor(.gray, for: .highlighted)
        converterButton.contentHorizontalAlignment = .center
        converterButton.backgroundColor = .lightGray
        //buttonConverter.autoresizingMask = [.flexibleBottomMargin]
        converterButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.view.addSubview(converterButton)
    }
    
    // Button target
    @objc func buttonPressed() {
        let converterVC = ConverterViewController()
        converterVC.currenciesArr = justDollarAndEuro
        self.navigationController?.pushViewController(converterVC, animated: true)
    }
    
    //MARK: - Create tableView
    private func createTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 4.2), style: .plain)
        tableView.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(tableView)
    }
    
    //MARK: - TableViewDelegate and TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return justDollarAndEuro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
        cell.textLabel?.text = "\(justDollarAndEuro[indexPath.row].cc)"
        cell.detailTextLabel?.text = "\(Double(round(justDollarAndEuro[indexPath.row].rate * 10) / 10))"
        
        return cell
    }
    
    //MARK: - Parse JSON
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCurrencies = try? decoder.decode([Currency].self, from: json) {
            currencies = jsonCurrencies
        } else {
            return
        }
    }
}

