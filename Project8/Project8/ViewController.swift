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
    // store the buttons that are currently being used to spell an answer
    var activatedButtons = [UIButton]()
    // all the possible solutions
    var solutions = [String]()
    // holds players score
    var score = 0 {
        // adding a property observer
        // didSet executes the code, when the property has just been set
        // as a result we update the score label whenever the score value was changed
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    // holds current level
    var level = 1
    
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
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "Clues"
        // 0 means as many lines as it takes
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
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
        // when the user presses the submit button, call submitTapped() on the current view controller
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
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
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
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
            clear.heightAnchor.constraint(equalToConstant: 44),
            // set the fixed width
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            // set the fixed height
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            // center horizontally
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // pin to the bottom of submit button + 20 points for spacing
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            // pin to the bottom of layout margin, but 20 points away from the screen edge
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            ])
        
        // set width and height for each button
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    
    }

    @objc func letterTapped(_ sender: UIButton) {
        // safe check to read the title on the button, exit if can't do it
        guard let buttonTitle = sender.titleLabel?.text else { return }
        // append button title to the player's current answer
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        // append button to the array
        // activatedButtons array is being used to hold all buttons that the player has tapped before submitting their answer
        activatedButtons.append(sender)
        // hide the button that was tapped
        sender.isHidden = true
        
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        // safely unwrapp, exit otherwise
        guard let answerText = currentAnswer.text else { return }
        // search through the solutions array for an item, if found stores the postion of it
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            
        }
        
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        // remove the text from the current aswer field
        currentAnswer.text = ""
        // show all the hidden buttons
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        // stores all level's clues
        var clueString = ""
        // stores how many letters each answer is (in the same position as the clues)
        var solutionString = ""
        // store all letter groups: HA, UNT, ED, and so on
        var letterBits = [String]()
        
        // find level string from the app bundle
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            // load the contents of it
            if let levelContents = try? String(contentsOf: levelFileURL) {
                // split the content of the file into array by breaking on the new line character
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                // using enumerated to go over each item in the lines array
                // enumerated() will place the item into the line variable and its position into the index variable
                for (index, line) in lines.enumerated() {
                    // split each line based on finding semicolon
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                    
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            //  looping from 0 to 19 (inclusive) means we can use the i variable to set a button to a letter group
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    
    func levelUp(action: UIAlertAction) {
        
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
        
    }
    
    
}

