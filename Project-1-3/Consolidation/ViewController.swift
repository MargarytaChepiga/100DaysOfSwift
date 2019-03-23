//
//  ViewController.swift
//  Consolidation
//
//  Created by margaret on 2019-03-19.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var flagImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Viewer"
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("2x.png") {
                flagImages.append(item)            }
        }
        
        print(flagImages)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagImages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flagImages[indexPath.row].dropLast(7).uppercased()
        cell.imageView?.image = UIImage(named: flagImages[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedFlagImage = flagImages[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

