//
//  DetailViewController.swift
//  CountriesFacts
//
//  Created by margaret on 2019-06-13.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var detailItem: Country?
    var dataToLoad = [String]()
    @IBOutlet weak var flag: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let detailItem = detailItem else { return }
        
        title = detailItem.name
        
        
        dataToLoad.append("Capital: \(detailItem.capital)")
        dataToLoad.append("Region: \(detailItem.region)")
        dataToLoad.append("Population: \(detailItem.population)")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToLoad.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.text = dataToLoad[indexPath.row]
        return cell
    }
    

}
