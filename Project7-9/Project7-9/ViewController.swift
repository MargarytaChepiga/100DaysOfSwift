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
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //buttonsView.layer.borderWidth = 1
        //buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            // word to guess label
            answerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            answerLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 120),
            // buttons view
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0),
            buttonsView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 10),
            buttonsView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 10)
        
           
        ])
        
        //answerLabel.backgroundColor = UIColor.red
        //buttonsView.backgroundColor = UIColor.green
        
        let buttonWidth = 55
        let buttonHeight = 55
        
        for row in 0..<5 {
            for col in 0..<6 {
                
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("A", for: .normal)
                
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * buttonWidth, y: row * buttonHeight , width: buttonWidth, height: buttonHeight)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
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
    
    @objc func letterTapped(_ sender: UIButton) {
        
        
        
    }
    
    
}

