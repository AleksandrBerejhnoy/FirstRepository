//
//  AddNewNoteViewController.swift
//  Day74_Milestone_P19-P21
//
//  Created by Pro on 12.11.2020.
//

import UIKit
import MobileCoreServices

class AddNewNoteViewController: UIViewController {
    
    var textView = UITextView()
    public var addNewNote: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Note"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        //MARK: - Creating Text View
        textView.frame = self.view.frame
        textView.font = UIFont(name: "ChalkboardSE-Light", size: 20)
        textView.becomeFirstResponder()
        view.addSubview(textView)
        
        if !textView.isFirstResponder {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneFunc))
        }
        
        //MARK: - Scrolling TextView when the keyboard closes the text
        let notoficationCenter = NotificationCenter.default
        notoficationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notoficationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func doneFunc() {
        textView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
    }
    
    @objc func saveNote() {
        addNewNote?(textView.text)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
}
