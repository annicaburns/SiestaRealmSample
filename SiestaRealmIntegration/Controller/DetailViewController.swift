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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    var statusOverlay = ResourceStatusOverlay()
    
    var repo: Resource? {
        
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.5)
            
            repo?.addObserver(self)
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
            infoView.hidden = (self.repo == nil)
            if let repository = repo {
                self.nameLabel.text = repository.json["name"].string
                self.urlLabel.text = repository.json["url"].string
            }

        }
    }
    
    // MARK: - ResourceObserver protocol

    func resourceChanged(resource: Resource, event: ResourceEvent) {
        print("resource: \(resource.json)")
        self.updateView()
    }
    
}
