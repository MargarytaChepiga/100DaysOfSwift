//
//  ViewController.swift
//  Project-4-6
//
//  Created by margaret on 2019-04-22.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Shopping List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addShoppingListItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(cleanShoppingList))
        
    }

    @objc func addShoppingListItem() {
        
        let ac = UIAlertController.init(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(submitAction)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        present(ac, animated: true)
        
    }
    
    @objc func cleanShoppingList() {
        
        let ac = UIAlertController.init(title: "Are you sure you want to delete the entire list?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            [weak self] action in
            self?.shoppingList.removeAll()
            self?.tableView.reloadData()
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
   
    }
    
    func submit(_ item: String) {
        
        shoppingList.insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
}

