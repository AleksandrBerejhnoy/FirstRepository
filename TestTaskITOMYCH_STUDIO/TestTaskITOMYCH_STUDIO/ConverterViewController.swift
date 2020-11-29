//
//  ConverterViewController.swift
//  TestTaskITOMYCH_STUDIO
//
//  Created by Pro on 28.11.2020.
//

import UIKit

class ConverterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var currenciesArr: [Currency]!
    private let uah = Currency(r030: 1, txt: "Гривня", rate: 1, cc: "UAH", exchangedate: "30.11.2020")
    
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    
    private let firstTextField = UITextField()
    private let secondTextField = UITextField()
    
    private let picker = UIPickerView()
    
    private var pickerRowCount = 0      //Show which element selected in picker
    private var whoWasTheLastTF = 1     //Show Who was chenged last from our text fields
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Customize view
        self.title = "Converter"
        self.view.backgroundColor = .white
        
        //MARK: - Add UAH to currenceisArr
        if currenciesArr != nil{
            currenciesArr.append(uah)
        }
        
        //MARK: - Adding subviews
        createLabel(label: firstLabel, tag: 1)
        createLabel(label: secondLabel, tag: 2)
        
        createTextField(textField: firstTextField, tag: 1)
        createTextField(textField: secondTextField, tag: 2)
        
        createPickerView()
        
    }
    //MARK: - Create pickerView
    private func createPickerView() {
        picker.frame = CGRect(x: 5, y: self.view.bounds.height / 8 + 60, width: self.view.bounds.width, height: self.view.bounds.height / 8)
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        self.view.addSubview(picker)
    }
    
    //MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: currenciesArr[row].cc, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currenciesArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRowCount = row
        firstLabel.text = "\(currenciesArr[row].cc)"
        if whoWasTheLastTF == 1 {               //If first textView changed last
            if firstTextField.text!.isEmpty {   //If first textView is empty
                firstTextField.text = "0.0"
            } else {
                guard let currency = Double(firstTextField.text!) else {
                    showErrowMessage()
                    return
                }
                secondTextField.text = "\(Double(round(currency * currenciesArr[row].rate * 100) / 100))"
            }
            
        } else if whoWasTheLastTF == 2 {        //If second textView changed last
            if secondTextField.text!.isEmpty {  //If second textView is empty
                secondTextField.text = "0.0"
            } else {
                guard let currency = Double(secondTextField.text!) else {
                    showErrowMessage()
                    return
                }
                firstTextField.text = "\(Double(round(currency / currenciesArr[row].rate * 100) / 100))"
            }
           
        }
        
    }
    
    //MARK: - showErrorMessage
    private func showErrowMessage() {
        let ac = UIAlertController(title: "Error", message: "Please, check last chenges!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    //MARK: - Create TextFields
    private func createTextField(textField: UITextField, tag: Int) {
        if tag == 1 {
            textField.tag = 1
            textField.frame = CGRect(x: self.view.bounds.width / 1.4, y: self.view.bounds.height / 8, width: self.view.bounds.width / 4, height: 50)
            textField.text = "1.00"
        } else if tag == 2{
            textField.tag = 2
            textField.frame = CGRect(x: self.view.bounds.width / 1.4, y: self.view.bounds.height / 8 * 3 , width: self.view.bounds.width / 4, height: 50)
            textField.text = "\(Double(round(currenciesArr[0].rate * 100) / 100))"
        } else {
            print("Error creating label")
        }
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.delegate = self
        //textField.allowsEditingTextAttributes = true
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 9
        self.view.addSubview(textField)
        
    }
    //MARK: - Hidde keyboard if pressed return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Catching changes in out textViews
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Changes in the first textView
        if textField.tag == 1 {
            whoWasTheLastTF = 1
            if string != "" {                   //If add character
                if range.location != 0 {
                    if let count = Double(firstTextField.text! + string) {
                        secondTextField.text = "\(Double(round(currenciesArr[pickerRowCount].rate * count * 100) / 100))"
                    } else {
                        showErrowMessage()
                    }
                } else {
                    if let count = Double(string) { //If secected all and insert something
                        secondTextField.text = "\(Double(round(currenciesArr[pickerRowCount].rate * count * 100) / 100))"
                    } else {
                        showErrowMessage()
                    }
                }
                
            } else {                            //If Delete character
                if let count = Double(firstTextField.text!.dropLast(1)) {
                    if range.location == 0 {    //If secected and deleted all numbers
                        secondTextField.text = "0.0"
                    } else {
                        secondTextField.text = "\(Double(round(currenciesArr[pickerRowCount].rate * count * 100) / 100))"
                    }
                } else {
                    let count = 0.0
                    secondTextField.text = "\(Double(round(currenciesArr[pickerRowCount].rate * count * 100) / 100))"
                }
            }
            
        }
        
        //Changes in the second textView
        else if textField.tag == 2 {
            whoWasTheLastTF = 2
            if string != ""{                    //If add character
                if range.location != 0 {        //If secected all and insert something
                    if let count = Double(secondTextField.text! + string) {
                        firstTextField.text = "\(Double(round(count / currenciesArr[pickerRowCount].rate * 100) / 100))"
                    } else {
                        showErrowMessage()
                    }
                } else {
                    if let count = Double(string) {
                        firstTextField.text = "\(Double(round(count / currenciesArr[pickerRowCount].rate * 100) / 100))"
                    } else {
                        showErrowMessage()
                    }
                }
            } else {                            //If Delete character
                if let count = Double(secondTextField.text!.dropLast(1)) {
                    if range.location == 0 {    //If secected and deleted all numbers
                        firstTextField.text = "0.0"
                    } else {
                        firstTextField.text = "\(Double(round(count / currenciesArr[pickerRowCount].rate * 100) / 100))"
                    }
                    
                } else {
                    let count = 0.0
                    firstTextField.text = "\(Double(round(currenciesArr[pickerRowCount].rate * count * 100) / 100))"
                }
            }
        } else {
            showErrowMessage()
        }
        return true
    }
    
    //MARK: - Create labels
    private func createLabel(label: UILabel, tag: Int) {
        if tag == 1 {
            label.tag = 1
            label.frame = CGRect(x: 5, y: self.view.bounds.height / 8, width: self.view.bounds.width / 1.5, height: 50)
            label.text = "USD"
        } else if tag == 2 {
            label.tag = 2
            label.frame = CGRect(x: 5, y: self.view.bounds.height / 8 * 3 , width: self.view.bounds.width / 1.5, height: 50)
            label.text = "UAH"
        } else {
            return
        }
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        label.backgroundColor = .white
        self.view.addSubview(label)
        
    }
}
