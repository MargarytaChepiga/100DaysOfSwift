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

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
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
        
        title = UserDefaults.standard.object(forKey: "currentWord") as? String ?? ""
        
        if let data = UserDefaults.standard.object(forKey: "words") as? Data {
            if let words = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] ?? [String]() {
                usedWords = words
                if usedWords.count > 0 {
                    self.tableView.reloadData()
                }
            }
        } else {
            startGame()
        }
        
        //startGame()
    }
    
    @objc func startGame() {
        // sets our view controller's title to be a random word in the array, which will be the word the player has to find
        title = allWords.randomElement()
        // removes all values from the usedWords array, which we'll be using to store the player's answers so far
        usedWords.removeAll(keepingCapacity: true)
        // table view is given to us as a property because our ViewController class comes from UITableViewController, and calling reloadData() forces it to call numberOfRowsInSection again, as well as calling cellForRowAt repeatedly. The method allows us to check we've loaded all the data correctly
        tableView.reloadData()
        
        UserDefaults.standard.set(title, forKey: "currentWord")
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
        
        // to avoid dealing with different cases, make the word to be always lovercased
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        // the three if statements are needed to make sure that the answer
        // that user is entering passing all the checks
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    // if all the checks are passed
                    // we insert the answer to the usedWords array at position 0
                    // to appear at the top of the table view
                    usedWords.insert(lowerAnswer, at: 0)
                    save()
                    // inser a new row into a table view
                    let indexPath = IndexPath(row: 0, section: 0)
                    // use insertRows method to animate the new cell appear
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                    showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
                showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
            showErrorMessage(errTitle: errorTitle, errMessage: errorMessage)
        }
        
    }
    
    func isPossible(word: String) -> Bool {
        
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        // returns true if array of usedWords does not have a word provided
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        // UITextChecker is an iOS class that is designed to spot spelling errors
        // create a new instance of the class and put it into the checker constant for later
        let checker = UITextChecker()
        // NSRange is used to store a string range, which is a value that holds a start position and a length
        let range = NSRange(location: 0, length: word.utf16.count)
        // returns another NSRange structure which tells us where the misspelling was found
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        // return true if no mispelling were found
        return misspelledRange.location == NSNotFound && word.count >= 3 && !title!.starts(with: word)
    }
    
    func showErrorMessage(errTitle: String, errMessage: String) {
        
        let ac = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK!", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: usedWords, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: "words")
        }
    }
}

