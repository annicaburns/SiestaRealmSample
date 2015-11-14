//
//  DetailViewController.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/10/15.
//

import UIKit
import Siesta

class DetailViewController: UIViewController, ResourceObserver {

    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    var statusOverlay = ResourceStatusOverlay()
    
    var repoList: Resource? {
        
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.5)
            
            repoList?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statusOverlay.embedIn(self)
        
        self.updateView()
    }
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCover(self.view)
    }
    
    // MARK: - Functions
    
    func updateView() {
        // Only attempt to update subviews is the view controller's primary view has loaded
        if (self.isViewLoaded() == true)  {
            infoView.hidden = (self.repoList == nil)
            if let repository = repoList?.repositoryArray.first {
                
                let shortDateFormatter = NSDateFormatter()
                shortDateFormatter.dateStyle = .ShortStyle
                
                self.label1.text = "Name: " + repository.name
                if let date = repository.createdDate {
                    let dateString = shortDateFormatter.stringFromDate(date)
                    self.label2.text = "Created: " + dateString
                }
                if let date = repository.updatedDate {
                    let dateString = shortDateFormatter.stringFromDate(date)
                    self.label3.text = "Updated: " + dateString
                }
                
                self.label4.text = "Watchers: " + String(repository.subscribers_count)
                self.label5.text = "Stargazers: " + String(repository.stargazers_count)
                if let repoOwner = repository.owner {
                    self.label6.text = "Owner: " + repoOwner.login
                } else {
                    self.label6.text = ""
                }

            }

        }
    }
    
    // MARK: - ResourceObserver protocol

    func resourceChanged(resource: Resource, event: ResourceEvent) {
        self.updateView()
    }
    
}
