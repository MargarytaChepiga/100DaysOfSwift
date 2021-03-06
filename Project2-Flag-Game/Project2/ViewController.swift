//
//  ViewController.swift
//  Project2
//
//  Created by margaret on 2019-03-12.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Conect the UI buttons to the code
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var timesAsked = 0
    
    var highestScore = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Declare an array of contries
        countries += ["canada", "estonia", "france", "germany", "ireland", "italy", "kazakhstan", "monaco", "nigeria", "poland", "russia", "spain", "uk", "ukraine", "us"]
        
        // Adding border to our flags
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // Changing the default color of the border
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    
        askQuestion()
        
        highestScore = UserDefaults.standard.integer(forKey: "score")
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        // shufling our array of countries, in order to get different flags every time we call the function
        countries.shuffle()
        
        // Assign each button to the randon flag
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        // This would give a randon number in a range from 0 to 2
        // Since we have 3 flags, a correct answer can be from 0 to 2
        correctAnswer = Int.random(in: 0...2)
        
        // Uppercase the name of the country to make it prettier
        // Plus, to cover the edge cases (UK & US for example)
        title = countries[correctAnswer].uppercased() + " " + "- SCORE: \(score)"
       
    }
    // IBAaction is a way of making storyboard layouts trigger code
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            // closure we don’t need to use [weak self] because there’s no risk of strong reference cycles here – the closures passed to animate(withDuration:) method will be used once then thrown away
            sender.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { finished in    //We use trailing closure syntax to provide our completion closure. This will be called when the animation completes, and its finished value will be true if the animations completed fully
        }
        
        // keep track of correct & wrong answers
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            timesAsked += 1
            defaults.set(score, forKey: "score")
            if score > highestScore && highestScore != 0 {
                let ac = UIAlertController(title: "You beat your high score", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(ac, animated: true)
            }
        } else {
            title = "Wrong"
            score -= 1
            timesAsked += 1
        }
        
      
        // Keep track of how many question the user have answered
        if timesAsked == 3  {
            
            highestScore = defaults.integer(forKey: "score")
            
            
            // show alert message with the final score
            let acon = UIAlertController(title: "Final Score", message: "Your final score is \(score).", preferredStyle: .alert)
            acon.addAction(UIAlertAction(title: "Start Over", style: .destructive, handler: askQuestion))
            present(acon, animated: true)
            score = 0
            timesAsked = 0
            
        }
        
        if title == "Wrong" {
            let wrongAns = UIAlertController(title: title, message: "That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
            wrongAns.addAction(UIAlertAction(title: "Try Again", style: .default, handler: askQuestion))
            present(wrongAns, animated: true)
        }
        
        // Important! Usage of closures!
        // Apple recommends you use .alert when telling users about a situation change, and .actionSheet when asking them to choose from a set of options.
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        // UIAlertAction data type to add a button to the alert that says "Continue", and gives it the style “default". There are three possible styles: .default, .cancel, and .destructive.
        // handler parameter is looking for a closure, which is some code that it can execute when the button is tapped
        // PLEASE NOTE: We must use askQuestion and not askQuestion(). If you use the former, it means "here's the name of the method to run," but if you use the latter it means "run the askQuestion() method now, and it will tell you the name of the method to run."
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // accepts viewController to present and whether to animate the presentation
      
        
        present(ac, animated: true)
        

    }
    
}

