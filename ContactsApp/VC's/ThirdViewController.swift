//
//  ThirdViewController.swift
//  ContactsApp
//
//  Created by Alper Canımoğlu on 6.01.2023.
//

import UIKit
import CoreData

class ThirdViewController: UIViewController {
    
    var chosenContact = ""
    var chosenContactID : UUID?
    
    @IBOutlet private weak var contactPP: UIImageView!
    @IBOutlet private weak var contactFirstNameLabel: UILabel!
    @IBOutlet private weak var contactLastNameLabel: UILabel!
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var locationTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Contact Details
        
        if chosenContact != "" {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
                let idString = chosenContactID?.uuidString
                fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
                fetchRequest.returnsDistinctResults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let contactFirstName = result.value(forKey: "firstName") as? String {
                                self.contactFirstNameLabel.text = contactFirstName
                            }
                            if let contactLastName = result.value(forKey: "lastName") as? String {
                                self.contactLastNameLabel.text = contactLastName
                            }
                            if let contactCompany = result.value(forKey: "companyName") as? String {
                                self.companyNameLabel.text = contactCompany
                            }
                            if let contactPhone = result.value(forKey: "phone") as? String {
                                self.phoneLabel.text = contactPhone
                            }
                            if let contactEmail = result.value(forKey: "email") as? String {
                                self.emailLabel.text = contactEmail
                            }
                            if let contactBirthday = result.value(forKey: "birthday") as? String {
                                self.birthdayLabel.text = contactBirthday
                            }
                            if let contactLocationTitle = result.value(forKey: "locationTitle") as? String {
                                self.locationTitleLabel.text = contactLocationTitle
                            }
                            if let contactProfilePhotoData = result.value(forKey: "contactImage") as? Data {
                                let image = UIImage(data: contactProfilePhotoData)
                                self.contactPP.image = image
                            }
                        }
                    }
                }catch{
                    Common.showAlert(errorTitle: "Error!", errorMessage: "Your data details could not displayed!", vc: self)
                }
            }
        }
        
    }
    
    @IBAction func callButton(_ sender: Any) {
    }
    
    @IBAction func messageSMSButton(_ sender: Any) {
        sendMessageToNumber(number: "\(phoneLabel.text!)")
    }
    
    @IBAction func goToMapsButton(_ sender: Any) {
        if let fourthVC = storyboard?.instantiateViewController(withIdentifier: "FourthVC") as? FourthViewController__MapKit_{
            navigationController?.pushViewController(fourthVC, animated: true)
        }
    }
    
    @IBAction func deleteCurrentContactButton(_ sender: Any) {
        // deleting proccess
    }
    
    func sendMessageToNumber(number:String){

        let sms = "sms:\(number)"
        let url = URL(string: sms)!
        let shared = UIApplication.shared

        if(shared.canOpenURL(url)){
                shared.open(url)
            }else{
                print("unable to send message")
            }
        }
    
}
