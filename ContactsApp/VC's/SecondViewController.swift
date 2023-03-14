//
//  SecondViewController.swift
//  ContactsApp
//
//  Created by Alper Canımoğlu on 6.01.2023.
//

import UIKit
import CoreData

final class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var contactPhoto: UIImageView!
    @IBOutlet private weak var firstNameText: UITextField!
    @IBOutlet private weak var lastNameText: UITextField!
    @IBOutlet private weak var companyNameText: UITextField!
    @IBOutlet private weak var phoneText: UITextField!
    @IBOutlet private weak var emailText: UITextField!
    @IBOutlet private weak var birthdayText: UITextField!
    @IBOutlet private weak var locationTitleText: UITextField!
    
    @IBOutlet private weak var saveContactOutButton: UIBarButtonItem!
    @IBOutlet private weak var addPhotoOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveContactOutButton.isEnabled = false
        //overrideUserInterfaceStyle = .light
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let userInterface = traitCollection.userInterfaceStyle
        if userInterface == .dark {
            self.view.backgroundColor = UIColor.black
            print("Dark Mode")
        }
    }
    
    @IBAction func addPhotoButton(_ sender: Any) {
        let tapImagePicker = UIImagePickerController()
        tapImagePicker.delegate = self
        tapImagePicker.sourceType = .photoLibrary
        tapImagePicker.allowsEditing = true
        present(tapImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        if let fourthVC = storyboard?.instantiateViewController(withIdentifier: "FourthVC") as? FourthViewController__MapKit_{
            navigationController?.pushViewController(fourthVC, animated: true)
        }
        
    }
    
    @IBAction func saveContactButton(_ sender: Any) {
        saveData()
        NotificationCenter.default.post(name: NSNotification.Name("newContact"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Image Picker Function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        contactPhoto.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.saveContactOutButton.isEnabled = true
        self.addPhotoOutButton.setTitle(" Edit photo", for: UIControl.State.normal)
    } // Image Picker Function
    
    // Save data (Core Data Func)
    
    func saveData(){
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: context)
            
            if firstNameText.text != "" && lastNameText.text != "" && companyNameText.text != "" && emailText.text != "" && locationTitleText.text != "" && phoneText.text != "" && birthdayText.text != "" && contactPhoto.image != nil {
                newContact.setValue(firstNameText.text!, forKey: "firstName")
                newContact.setValue(lastNameText.text!, forKey: "lastName")
                newContact.setValue(companyNameText.text!, forKey: "companyName")
                newContact.setValue(emailText.text!, forKey: "email")
                newContact.setValue(locationTitleText.text!, forKey: "locationTitle")
                newContact.setValue(phoneText.text!, forKey: "phone")
                newContact.setValue(birthdayText.text, forKey: "birthday")
                newContact.setValue(UUID(), forKey: "id")
                let imageData = contactPhoto.image?.jpegData(compressionQuality: 0.5)
                newContact.setValue(imageData, forKey: "contactImage")
                
                do{
                    try context.save()
                }catch{
                    Common.showAlert(errorTitle: "Error!", errorMessage: "Your data could not be saved!", vc: self)
                }
            }else{
                Common.showAlert(errorTitle: "Missing entry!", errorMessage: "Please enter all of contact data!", vc: self)
            }
        }
        
    } // Save data (Core Data Func)

    
}
