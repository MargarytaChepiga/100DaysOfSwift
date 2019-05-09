//
//  ViewController.swift
//  Hangman
//
//  Created by margaret on 2019-05-03.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    // letters in English alphabet
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    // list of words to solve
    let wordsToSolve = ["SWIFT", "BRAVE", "PASSION", "MOTIVATION"]
    // word to guess for one game / level
    var wordToGuess = ""
    // used to display the word to guess in a hidden way
    var hiddenWord = "" {
        didSet {
            answerLabel.text = "\(hiddenWord)"
        }
    }
    // used to keep track of amount of attemps the user have left
    var tryiesAmount = 7
    
    // displays hidden word
    var answerLabel: UILabel!
    // displays alphabet buttons
    var letterButtons = [UIButton]()
    
    let widthHeight = 4
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.text = randomWord()
        answerLabel.font = UIFont.systemFont(ofSize: 32)
        view.addSubview(answerLabel)
        
        // view for the alphabet buttons
        let letterButtonsView = UIView()
        letterButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterButtonsView)
        
        // line images are for the gallons
        let lineImage = UIImageView(frame: CGRect(x: 100, y: 170, width: 9, height: 300))
        lineImage.backgroundColor = UIColor.black
        lineImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineImage)
        
        let lineImage2 = UIImageView(frame: CGRect(x: 60, y: 470, width: 130, height: 10))
        lineImage2.backgroundColor = UIColor.black
        lineImage2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineImage2)
        
        let lineImage3 = UIImageView(frame: CGRect(x: 100, y: 170, width: 160, height: 8))
        lineImage3.backgroundColor = UIColor.black
        lineImage3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineImage3)
        
        let lineImage4 = UIImageView(frame: CGRect(x: 260, y: 170, width: 6, height: 30))
        lineImage4.backgroundColor = UIColor.black
        lineImage4.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineImage4)
        
        drowLine(startX: 106, toEndingX: 152, startingY: 220, toEndingY: 176)
        
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 35),
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
    
    }

    func randomWord() -> String {
        // get a random word from the array of all the words
        wordToGuess = wordsToSolve.randomElement()!
        // store it for the future use
        hiddenWord = wordToGuess
        // remove all charaters, but keep the capacity
        hiddenWord.removeAll(keepingCapacity: true)
        
        // add same amount of "?" as the random word has characters
        for _ in 0..<wordToGuess.count {
            hiddenWord.append("?")
        }
        
        return hiddenWord
        
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
                // hide the button that was tapped
                sender.isHidden = true
                
            }
            // if word is guessed, show alert and load new game
            if !hiddenWord.contains("?") {
                let alert = UIAlertController(title: "You won!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "I want to play more!", style: .default, handler: { [weak self] action in
                    self?.loadGame()
                }))
                present(alert, animated: true)
            }
        }
        // if wrong letter was pressed
        if !wordToGuess.contains(buttonTitle) {
            // decrease the score by 1
            tryiesAmount -= 1
            // call the function to check the score, and add apripriate images to the view
            scoreCheck()
            // hide the button
            sender.isHidden = true
            // if all the attemps were used by the user, show alert and load new game
            if tryiesAmount <= 1 {
                
                let alert = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .cancel, handler: { [weak self ] action in
                    self?.loadGame()
                }))
                present(alert, animated: true)
 
            }
            
        }
        
    }
    
    func nameTheButtons() {
        // show all the buttons on the view
        for btn in letterButtons {
            btn.isHidden = false
        }
        // name the buttons
        for button in 0..<letterButtons.count {
            letterButtons[button].setTitle(alphabet[button], for: .normal)
        }
        
    }
    
    func scoreCheck() {
        // depending on the amount of attems user have left, add respective image
        switch tryiesAmount {
        // drow a head
        case 6:
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: 263,y: 222), radius: CGFloat(24), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = circlePath.cgPath
            
                    //change the fill color
                    shapeLayer.fillColor = UIColor.clear.cgColor
                    //you can change the stroke color
                    shapeLayer.strokeColor = UIColor.black.cgColor
                    //you can change the line width
                    shapeLayer.lineWidth = 4.0
            
                view.layer.addSublayer(shapeLayer)
        // drow body line
        case 5:
            drowLine(startX: 261, toEndingX: 261, startingY: 244, toEndingY: 344)
        // drow left hand
        case 4:
            drowLine(startX: 261, toEndingX: 231, startingY: 265, toEndingY: 310)
        // drow right hand
        case 3:
            drowLine(startX: 262, toEndingX: 295, startingY: 265, toEndingY: 310)
        // drow left leg
        case 2:
            drowLine(startX: 261, toEndingX: 235, startingY: 343, toEndingY: 425)
        // drow right leg
        case 1:
            drowLine(startX: 262, toEndingX: 291, startingY: 343, toEndingY: 425)
        default:
            print("Do nothin")
        }
        
        
    }
    
    func drowLine(startX: Int, toEndingX endX: Int, startingY startY: Int, toEndingY endY: Int) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 4.0
        
        view.layer.addSublayer(shapeLayer)
    }

    func loadGame() {
        
        tryiesAmount = 7
        nameTheButtons()
        answerLabel.text = randomWord()
        
        print(view.layer.sublayers!.count)
        // depending on the amont of drowings added, remove the from the view
        if view.layer.sublayers!.count > 7 {
            let allSubs = view.layer.sublayers
            let amountOfLayersToRemove = view.layer.sublayers!.count
            switch amountOfLayersToRemove {
            case 8:
                view.layer.sublayers = allSubs?.dropLast(1)
            case 9:
                view.layer.sublayers = allSubs?.dropLast(2)
            case 10:
                view.layer.sublayers = allSubs?.dropLast(3)
            case 11:
                view.layer.sublayers = allSubs?.dropLast(4)
            case 12:
                view.layer.sublayers = allSubs?.dropLast(5)
            case 13:
                view.layer.sublayers = allSubs?.dropLast(6)
            default:
                print("Do nothing")
            }
           
        }
        
        print(view.layer.sublayers!.count)
        
    }
    
}

