//
//  ViewController.swift
//  Picture-Capture-App
//
//  Created by margaret on 2019-05-22.
//  Copyright © 2019 margaret. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "pictures") as? Data {
            if let decodedPictures = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Picture] {
                pictures = decodedPictures
            }
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewImage))
       
    }

    @objc func addNewImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        print(UIImagePickerController.isSourceTypeAvailable(.camera))
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            
            fatalError("Unable to dequeue PersonCell.")

        }
        
        let picture = pictures[indexPath.row]
        
        if picture.name == "Unknown" {
            let renameAlert = UIAlertController(title: "Remane the pic!", message: nil, preferredStyle: .alert)
            renameAlert.addTextField()
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak renameAlert] _ in
                guard let newName = renameAlert?.textFields?[0].text else { return }
                picture.name = newName
                
                self?.tableView.reloadData()
                self?.save()
                
            })
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
            present(renameAlert, animated: true)
        }
       
        
        cell.name.text = picture.name
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.pictureImage)
        cell.pictureImage.image = UIImage(contentsOfFile: path.path)
        
        cell.pictureImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.pictureImage.layer.borderWidth = 2
        cell.pictureImage.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        if cell.isSelected {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        return cell
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Picture(name: "Unknown", pictureImage: imageName)
        pictures.append(picture)
        tableView.reloadData()
        
        dismiss(animated: true)
        save()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let renameAlert = UIAlertController(title: "Remane the pic!", message: nil, preferredStyle: .alert)
        renameAlert.addTextField()
        renameAlert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak renameAlert] _ in
            guard let newName = renameAlert?.textFields?[0].text else { return }
            self?.pictures[indexPath.row].name = newName
            self?.tableView.reloadData()
            //self.save()
        })
        renameAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        let alertCtr = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        alertCtr.addAction(UIAlertAction(title: "Rename Image", style: .default, handler: {
            [weak self] _ in
            self?.present(renameAlert, animated: true)
        }))
        alertCtr.addAction(UIAlertAction(title: "View Image", style: .default, handler: {
            [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedImage = self?.pictures[indexPath.row]
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alertCtr.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alertCtr, animated: true)
        
        
    }

    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            save()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    
}

