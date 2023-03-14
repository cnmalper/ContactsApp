//
//  ViewController.swift
//  ContactsApp
//
//  Created by Alper Canımoğlu on 6.01.2023.
//  Used pushViewController instead of Segue.
//  New Contact adding button has been set programmatically.

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var myColorList = [UIColor.red, UIColor.brown, UIColor.blue, UIColor.cyan, UIColor.orange, UIColor.darkGray, UIColor.green, UIColor.systemPink, UIColor.purple, UIColor.magenta, UIColor.yellow]
    private var contactFirstnameArray = [String]()
    private var contactLastnameArray = [String]()
    private var contactIdArray = [UUID]()
    
    private var selectedContact = ""
    private var selectedContactID : UUID?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView

        tableView.delegate = self
        tableView.dataSource = self

        // getContact Function
        
        getContact()
        
        //overrideUserInterfaceStyle = .light
    }
    
    @IBAction func addNewContactButton(_ sender: Any) {
        
        if let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? SecondViewController {
            navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getContact), name: NSNotification.Name("newContact"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.nameSurnameLabel.text = (self.contactFirstnameArray[indexPath.row] + " " + self.contactLastnameArray[indexPath.row])
        let chosenColor = self.myColorList.randomElement()!
        cell.contactSymbol.tintColor = chosenColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "ThirdVC") as? ThirdViewController{
            navigationController?.pushViewController(thirdVC, animated: true)
            self.selectedContact = contactFirstnameArray[indexPath.row]
            self.selectedContactID = contactIdArray[indexPath.row]
            thirdVC.chosenContact = selectedContact
            thirdVC.chosenContactID = selectedContactID
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
                let idString = contactIdArray[indexPath.row].uuidString
                fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
                fetchRequest.returnsDistinctResults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let id = result.value(forKey: "id") as? UUID {
                                if id == contactIdArray[indexPath.row] {
                                    
                                    context.delete(result)
                                    contactFirstnameArray.remove(at: indexPath.row)
                                    contactLastnameArray.remove(at: indexPath.row)
                                    contactIdArray.remove(at: indexPath.row)
                                    self.tableView.reloadData()
                                    
                                    do{
                                        try context.save()
                                    }catch{
                                        Common.showAlert(errorTitle: "Error!", errorMessage: "Data could not deleted!", vc: self)
                                    }
                                    break
                                }
                            }
                        }
                    }
                }catch{
                    Common.showAlert(errorTitle: "Error!", errorMessage: "Error on your Request!", vc: self)
                }
            }
            }
    }
    // getContact Function
    
    @objc func getContact(){
        
        self.contactIdArray.removeAll(keepingCapacity: false)
        self.contactLastnameArray.removeAll(keepingCapacity: false)
        self.contactFirstnameArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        fetchRequest.returnsDistinctResults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let contactFirstName = result.value(forKey: "firstName") as? String {
                    self.contactFirstnameArray.append(contactFirstName)
                }
                if let contactLastName = result.value(forKey: "lastName") as? String {
                    self.contactLastnameArray.append(contactLastName)
                }
                if let contactID = result.value(forKey: "id") as? UUID {
                    self.contactIdArray.append(contactID)
                }
            }
            tableView.reloadData()
        }catch{
            Common.showAlert(errorTitle: "Error!", errorMessage: "Contact data could not retrieved!", vc: self)
        }
        
    } // getContact Function

    
}

