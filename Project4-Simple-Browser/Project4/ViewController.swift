//
//  ViewController.swift
//  Project4
//
//  Created by margaret on 2019-03-28.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var websites = ["apple.com", "hackingwithswift.com", "brave.com", "google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedWebsite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

