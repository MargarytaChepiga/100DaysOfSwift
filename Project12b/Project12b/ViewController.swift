//
//  ViewController.swift
//  Project10
//
//  Created by margaret on 2019-05-14.
//  Copyright © 2019 margaret. All rights reserved.
//
import UIKit

// tell Swift you promise your class supports all the functionality required by the two protocols UIImagePickerControllerDelegate and UINavigationControllerDelegate
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    @objc func addNewPerson() {
        
        let picker = UIImagePickerController()
        // allows the user to crop the picture they select
        picker.allowsEditing = true
        print(UIImagePickerController.isSourceTypeAvailable(.camera))
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            picker.sourceType = .camera
        }
        //picker.sourceType = .camera
        // you'll need to conform not only to the UIImagePickerControllerDelegate protocol, but also the UINavigationControllerDelegate protocol
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    //  delegate method which returns when the user selected an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let person = people[indexPath.item]
        
        let renameAlert = UIAlertController(title: "Remane the contact", message: nil, preferredStyle: .alert)
        renameAlert.addTextField()
        renameAlert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak renameAlert] _ in
            guard let newName = renameAlert?.textFields?[0].text else { return }
            person.name = newName
            
            self?.collectionView.reloadData()
            self?.save()
            
        })
        renameAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        let alert = UIAlertController(title: "Do you want to rename or delete a contact?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: {
            [weak self] _ in
            self?.present(renameAlert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
            self?.people.remove(at: indexPath.row)
            self?.collectionView.reloadData()
            self?.save()
        }))
        
        present(alert, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
}

