//
//  ViewController.swift
//  CountriesFacts
//
//  Created by margaret on 2019-06-13.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    var filteredCountires = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries Facts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter))
        // fetch json on the background thread
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountires.count //countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredCountires[indexPath.row].name//countries[indexPath.row].name
        return cell
    }

    func parse(json: Data) {
    
        let decoder = JSONDecoder()
    
        if let jsonCountries = try? decoder.decode([Country].self, from: json) {
            countries = jsonCountries
            filteredCountires = countries
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.detailItem = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func fetchJSON() {
        let urlString = "https://restcountries.eu/rest/v2/all"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func filter() {
        let ac = UIAlertController(title: "Enter a country name you are searching for", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let searchString = ac?.textFields?[0].text else { return }
            self?.submit(searchString)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ searchString: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            // to show only those petitions that match the user provided string
            self?.filteredCountires.removeAll(keepingCapacity: true)
            
            // loop through all the countries
            for country in self!.countries {
                // if the provided string was found
                if country.name.contains(searchString) {
                    // then add the country to the array aka display it
                    self?.filteredCountires.append(country)
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                    
                }
            }
            
            // if search word was not found, show empty table and an alert
            if self?.filteredCountires.count == 0 {
                DispatchQueue.main.async { [weak self] in
                    
                    let ac = UIAlertController(title: "No match found", message: "Please try another country", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok!", style: .cancel))
                    self?.present(ac, animated: true)
                    
                    self?.tableView.reloadData()
                }
            }
            // if user does not provide a string, show all the counries
            if searchString == "" {
                self?.filteredCountires = self!.countries
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            }
            
        }
    }
}

