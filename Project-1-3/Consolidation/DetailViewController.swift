//
//  DetailViewController.swift
//  Consolidation
//
//  Created by margaret on 2019-03-21.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedFlagImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedFlagImage?.dropLast(7).uppercased()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        //.backgroundColor = UIColor(hue: 0.9917, saturation: 0, brightness: 0.97, alpha: 1.0) /* #f7f7f7 */
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let imageToLoad = selectedFlagImage {
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
    
    @objc func shareTapped() {
        guard let image =  imageView.image?.pngData() else {
            print("No image found")
            return
        }
        
        guard let imageTitle = selectedFlagImage?.dropLast(7).uppercased() else {
            print("No title found")
            return
        }
        let shareItems: [Any] = [image, imageTitle]
        
        let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
