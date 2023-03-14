//
//  FourthViewController-(MapKit).swift
//  ContactsApp
//
//  Created by Alper Canımoğlu on 9.01.2023.
//

import UIKit
import MapKit

class FourthViewController__MapKit_: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.mapView.isUserInteractionEnabled = true
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            self.mapView.isUserInteractionEnabled = false
            
            if response == nil
            {
                Common.showAlert(errorTitle: "Error!", errorMessage: "Something went wrong!", vc: self)
            }
            else
            {
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
            }
        }
        
    }

    @IBAction func searchButton(_ sender: Any)
    {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
}
