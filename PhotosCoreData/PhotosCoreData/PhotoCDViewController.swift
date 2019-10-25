//
//  PhotoCDViewController.swift
//  PhotosCoreData
//
//  Created by Alex Davis on 10/25/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//

import UIKit

class PhotoCDViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var photo = [Photos]()
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPhotos()
        photoCDTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.title
        if let addDate = photo.addDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: addDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.deletePhoto(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? PhotoCDTableViewController else {
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "photo", let indexPathForSelectedRow = photoTableView.indexPathForSelectedRow {
            destination.photo = photos[indexPathForSelectedRow.row]
        }
    }
    
    func fetchPhotss() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            photos = [photo]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rawDate", ascending: true)]
        
        do {
            photos = try managedContext.fetch(fetchRequest)
        } catch {
            
        }
    }
    
    func deletePhoto(indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        if let managedObjectContext = photo.managedObjectContext {
            managedObjectContext.delete(photo)
            
            do {
                try managedObjectContext.save()
                self.photos.remove(at: indexPath.row)
                photosTableView.reloadData()
            } catch {
                photosTableView.reloadData()
            }
        }
    }

}
