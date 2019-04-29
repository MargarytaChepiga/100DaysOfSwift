//
//  ViewController.swift
//  Project8
//
//  Created by margaret on 2019-04-26.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        // make constrains by hand
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "Clues"
        // 0 means as many lines as it takes
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "Answer"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // buttons are created here and not in view controller, because there is no need to adjust them later
        // create button with default button style
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        // set the title for the button
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        // creating container view for the buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // get all the constraint and activate them all at once
        NSLayoutConstraint.activate([
            // layoutmarginsGuide is used to add a distance from the edge of the screen
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: scoreLabel.heightAnchor),
            // make the text field be at the center of the screen
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // make the text field width to take up of 50% of the available space
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            // pin the top of text field to the bottom of the cluesLabel bottom
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            // make the submit button appear under the text field
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            // set the submit button on the center of the view and substruct 70 to place it on the left
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            // set the height of the button to be exactly 44 points as recommended by Apple interface guidelines
            submit.heightAnchor.constraint(equalToConstant: 44),
            // make the clear button appear under the text field
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
             // set the clear button on the center of the view and add 70 to place it on the right side
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            // set the height of the button to be exactly 44 points as recommended by Apple interface guidelines
            clear.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        //cluesLabel.backgroundColor = .red
        //answersLabel.backgroundColor = .blue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

