//
//  DetailViewController.swift
//  Day74_Milestone_P19-P21
//
//  Created by Pro on 11.11.2020.
//

import UIKit
import MobileCoreServices

class DetailViewController: UIViewController {
    
    var detailTitle: String!
    var text: String!
    var myTextView = UITextView()
    var index: Int!
    public var completion: ((String) -> Void)?
    public var deleteNote: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        title = detailTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        //MARK: - Creating Tool Bar
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let delete = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(removeNote))
        toolbarItems = [delete, space, share]
        navigationController?.setToolbarHidden(false, animated: true)
        
        //MARK: - Adding Text View
        addTextView()
        
        //MARK: - Scrolling TextView when the keyboard closes the text
        let notoficationCenter = NotificationCenter.default
        notoficationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notoficationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            myTextView.contentInset = .zero
        } else {
            myTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        myTextView.scrollIndicatorInsets = myTextView.contentInset
        
        let selectedRange = myTextView.selectedRange
        myTextView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func shareNote() {
        if let myText = myTextView.text {
            let ac = UIActivityViewController(activityItems: [myText], applicationActivities: [])
            present(ac, animated: true)
        }
    }
    
    @objc func removeNote() {
        deleteNote!()
    }
    
    @objc func saveNote() {
        if let myText = myTextView.text {
            completion?(myText)
        }
    }
    
    func addTextView() {
        myTextView.frame = self.view.bounds
        myTextView.font = UIFont(name: "ChalkboardSE-Light", size: 20)
        myTextView.becomeFirstResponder()
        //print("DetailView: \(myTextView.isFirstResponder)")
        self.view.addSubview(myTextView)
        
        if !myTextView.isFirstResponder {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneFunc))
        }
        
        myTextView.text = text
    }
    
    @objc func doneFunc() {
        myTextView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
    }
    
}
