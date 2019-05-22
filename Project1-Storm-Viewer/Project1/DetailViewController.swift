//
//  DetailViewController.swift
//  Project1
//
//  Created by margaret on 2019-03-11.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedImageCount = 0
    var totalAmountOfImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(selectedImageCount + 1) of \(totalAmountOfImages)"
        
        navigationItem.largeTitleDisplayMode = .never

        let defaults = UserDefaults.standard
        var count: Int = defaults.integer(forKey: selectedImage!)
        count += 1
        defaults.set(count, forKey: selectedImage!)
        print(defaults.integer(forKey: selectedImage!))
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
