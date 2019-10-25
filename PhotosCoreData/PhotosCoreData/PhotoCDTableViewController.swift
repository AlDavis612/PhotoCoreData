//
//  PhotoCDTableViewController.swift
//  PhotosCoreData
//
//  Created by Alex Davis on 10/25/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//
import UIKit

class PhotoCDTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    let newDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    var photo: Photo?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        bodyTextView.layer.cornerRadius = 6.0
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        newDateFormatter.dateStyle = .medium

        if let photo = photo {
            titleTextField.text = photo.title
            bodyTextView.text = photo.body
            if let addDate = photo.addDate {
                dateLabel.text = dateFormatter.string(from: addDate)
            }
            image = photo.image
            imageView.image = image
        } else {
            titleTextField.text = ""
            bodyTextView.text = ""
            dateLabel.text = newDateFormatter.string(from: Date(timeIntervalSinceNow: 0))
            imageView.image = nil
        }
    }

    @IBAction func selectImage(_ sender: Any) {
        selectImageSource()
    }

    func selectImageSource() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        image = selectedImage
        imageView.image = image
        if let photo = photo {
            photo.image = selectedImage
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            alertNotifyUser(message: "Please enter a title")
            return
        }
        
        if let photo = photo {
            photo.title = title
            photo.body = bodyTextView.text
            photo.image = image
        } else {
            photo = photo(title: title, body: bodyTextView.text, image: image)
        }
        
        if let photo = photo {
            do {
                let managedContext = photo.managedObjectContext
                try managedContext?.save()
            } catch {

            }
            
        } else {
        }
        
        navigationController?.popViewController(animated: true)
    }
}
