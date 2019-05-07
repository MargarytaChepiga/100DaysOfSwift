//
//  ViewController.swift
//  Hangman
//
//  Created by margaret on 2019-05-03.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /*
     
     Things to do:
     
     - Create a modifieble UI label on top of the screen
     - Display 26 letters
     -
     
     
    */
    
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let wordsToSolve = ["SWIFT", "BRAVE", "PASSION", "MOTIVATION", "ABRAKADABRA"]
    var wordToGuess = ""
    var hiddenWord = ""
    
    var testWord = ""
    
    var answerLabel: UILabel!
    var letterButtons = [UIButton]()
    
    // store letters that are being in use to spell an answer
    var activatedButtons = [UIButton]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        randomWord()
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.text = hiddenWord
        answerLabel.font = UIFont.systemFont(ofSize: 32)
        view.addSubview(answerLabel)
        
        let letterButtonsView = UIView()
        letterButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterButtonsView)
        
  
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
            letterButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letterButtonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0),
            letterButtonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1),
            letterButtonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.4),
            
        ])
        
        // Create 26 letter buttons
        let width = 73
        let height = 55

        for row in 0..<5 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 34)
                letterButton.setTitle("A", for: .normal)

                let frame = CGRect(x: width * col, y: height * row, width: width, height: height)
                letterButton.frame = frame

                letterButtons.append(letterButton)
                letterButtonsView.addSubview(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }

        let letter = UIButton(type: .system)
        letter.titleLabel?.font = UIFont.systemFont(ofSize: 34)
        letter.setTitle("A", for: .normal)
        let frame = CGRect(x: width * 2, y: height * 5, width: width, height: height)
        letter.frame = frame

        letterButtons.append(letter)
        letterButtonsView.addSubview(letter)
        letter.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        
        //answerLabel.backgroundColor = UIColor.red
        //letterButtonsView.backgroundColor = UIColor.green
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTheButtons()
    }

    func randomWord() {
        wordToGuess = wordsToSolve.randomElement()!
        hiddenWord = wordToGuess
        hiddenWord.removeAll(keepingCapacity: true)
        
        testWord = wordToGuess
        
        print(wordToGuess)
        // hide the word
        for _ in 0..<wordToGuess.count {
            hiddenWord.append("?")
        }
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        // safely unwrapp the button text, exit otherwise
        guard let buttonTitle = sender.titleLabel?.text else { return }
        // we need a char ( and not a string ) in order to get an index later
        let title = Character(buttonTitle)
        // loop through all the letters in the word
        for letter in wordToGuess {
            // if word has a letter that user typed
            if letter == title {
                // then find the position of this letter in the word
                guard let index = wordToGuess.firstIndex(of: title) else { return }
                // and last position of this letter -> in case we have more than one occuruncies of this letter in the word
                guard let lastIndex = wordToGuess.lastIndex(of: title) else { return }
                // remove the "?" from the hidden word -> to make space for the letter
                hiddenWord.remove(at: index)
                // insert letter at the same position as it was in the original word
                hiddenWord.insert(title, at: index)
                // in case where we have more than one occuruncies of the same letter in the word, do the same as above
                hiddenWord.remove(at: lastIndex)
                hiddenWord.insert(title, at: lastIndex)
                // modify the label text to be up to date
                // consider adding property observer instead of this line
                answerLabel.text = hiddenWord
            }
        }
        
        sender.isHidden = true
        
    }
    
    func nameTheButtons() {
        
        for button in 0..<letterButtons.count {
            letterButtons[button].setTitle(alphabet[button], for: .normal)
        }
        
    }
    

}

