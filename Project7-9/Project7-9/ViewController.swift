//
//  ViewController.swift
//  Project7-9
//
//  Created by margaret on 2019-05-02.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // contains 5 letter words for the game
    var words = ["APPLE", "PIZZA", "SWIFT", "JUICY", "CRAZY"]
    // contains the one words user need to gueess
    var wordToGuess = ""
    //
    var hiddenWord = ""
    
    var answerLabel: UILabel!
    var letterButtons = [UIButton]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // returns a random word
        randomWord()
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.textAlignment = .center
        answerLabel.text = hiddenWord
        answerLabel.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(answerLabel)
        
        // creating button container
        
        
        
        NSLayoutConstraint.activate([
           answerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
           answerLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 120),
        ])
        
        answerLabel.backgroundColor = UIColor.red
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func randomWord() {
        wordToGuess = words.randomElement()!
        
        for _ in 0..<wordToGuess.count {
            hiddenWord.append("_ ")
        }
        
    }
    
    
}

