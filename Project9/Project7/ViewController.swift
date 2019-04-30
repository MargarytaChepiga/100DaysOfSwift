//
//  ViewController.swift
//  Project7
//
//  Created by margaret on 2019-04-23.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter))
        
        let urlString: String
        // check whether we want to display the most recent or top rated
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count//petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]//petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        
        let ac = UIAlertController(title: "Credit", message: "Data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func filter() {
        
        let ac = UIAlertController(title: "Enter a word you want to filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let searchString = ac?.textFields?[0].text else { return }
            self?.submit(searchString)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ searchString: String) {
        
        // to show only those petitions that match the user provided string
        filteredPetitions.removeAll(keepingCapacity: true)
        
        // loop through all the petitions
        for petition in petitions {
            // if the provided string was found
            if petition.title.contains(searchString) || petition.body.contains(searchString) {
                // then add the petition to the array aka display it
                filteredPetitions.append(petition)
                tableView.reloadData()

            }
        }
       
        // if search word was not found, show empty table and an alert
        if filteredPetitions.count == 0 {
            let ac = UIAlertController(title: "No match found", message: "Please try another keyword", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok!", style: .cancel))
            present(ac, animated: true)
            tableView.reloadData()
        }
        // if user does not provide a string, show all the petitions
        if searchString == "" {
            filteredPetitions = petitions
            tableView.reloadData()
            
        }
        
    }
    
}

