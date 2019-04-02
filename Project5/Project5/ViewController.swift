//
//  ViewController.swift
//  Project5
//
//  Created by margaret on 2019-03-31.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // created a new UIBarButtonItem using the "add" system item, and configured it to run a method called promptForAnswer() when tapped
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

        // create a String instance from the contents of a file at a particular path
        // use a built-in method of Bundle to find a file with words
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // try? means "call this code, and if it throws an error just send me back nil instead. Which means the code you call will always work, but you need to unwrap the result carefully
            // split our single string into an array of strings based on wherever we find a line break
            if let startWords = try? String(contentsOf: startWordsUrl) {
                // Tell the method what string you want to use as a separator (for us, that's \n), and you'll get back an array that we store in our variable
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        // returns true if the array is empty, isEmpty is more efficient then checking manually (in Strings)
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        // sets our view controller's title to be a random word in the array, which will be the word the player has to find
        title = allWords.randomElement()
        // removes all values from the usedWords array, which we'll be using to store the player's answers so far
        usedWords.removeAll(keepingCapacity: true)
        // table view is given to us as a property because our ViewController class comes from UITableViewController, and calling reloadData() forces it to call numberOfRowsInSection again, as well as calling cellForRowAt repeatedly. The method allows us to check we've loaded all the data correctly
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        // create alert
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // method just adds an editable text input field to the UIAlertController
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        //  method is used to add a UIAlertAction to a UIAlertController
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
    }
}

