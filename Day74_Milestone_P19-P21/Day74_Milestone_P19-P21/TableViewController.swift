//
//  TableViewController.swift
//  Day74_Milestone_P19-P21
//
//  Created by Pro on 11.11.2020.
//

import UIKit

class TableViewController: UITableViewController {
    
    var allNotes = [String]()
    var text: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All Notes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNewNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CleanUD", style: .done, target: self, action: #selector(cleanUD))
        
        //MARK: - reading allNotes from file
        if let startWordsURL = Bundle.main.url(forResource: "Esenin", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allNotes = startWords.components(separatedBy: "Заметка")
            }
        }
        allNotes.removeFirst()
        
        //MARK: - readinf AllNotes from UserDefaults
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.stringArray(forKey: "allNotes") {
            allNotes = savedNotes
        }
        
    }
    
    @objc func cleanUD() {
        UserDefaults.standard.removePersistentDomain(forName: "allNotes")
        tableView.reloadData()
    }
    
    @objc func addNewNote() {
        let ncv = AddNewNoteViewController()
        ncv.addNewNote = { text in
            self.allNotes.append(text)
            self.tableView.reloadData()
            self.navigationController?.popToRootViewController(animated: true)
            self.save()
        }
        
        navigationController?.pushViewController(ncv, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = "Note \(indexPath.row + 1)"
        cell.detailTextLabel?.text = allNotes[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.detailTitle = "Note \(indexPath.row + 1)"
        dvc.text = allNotes[indexPath.row]
        dvc.index = indexPath.row
        dvc.completion = { text in
            self.navigationController?.popToRootViewController(animated: true)
            self.allNotes[indexPath.row] = text
            self.tableView.reloadData()
            self.save()
        }
        
        dvc.deleteNote = {
            self.allNotes.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.navigationController?.popToRootViewController(animated: true)
            self.save()
        }
        
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    //MARK:  - Delete using swipe 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.allNotes.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        return [editAction]
    }
    
    //MARK: - save allNotes to UserDefaults
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(allNotes, forKey: "allNotes")
    }
    
}
