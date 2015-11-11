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
                
                let rfc3339DateFormatter = NSDateFormatter()
                let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
                rfc3339DateFormatter.locale = enUSPOSIXLocale
                rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                rfc3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                
                let shortDateFormatter = NSDateFormatter()
                shortDateFormatter.dateStyle = .ShortStyle
                
                if let nameString = repository.json["name"].string {
                    self.label1.text = "Name: " + nameString
                }
                if let createdDate = repository.json["created_at"].string, let date = rfc3339DateFormatter.dateFromString(createdDate) {
                    let dateString = shortDateFormatter.stringFromDate(date)
                    self.label2.text = "created: " + dateString
                    
                }
                if let updatedDate = repository.json["updated_at"].string, let date = rfc3339DateFormatter.dateFromString(updatedDate) {
                    let dateString = shortDateFormatter.stringFromDate(date)
                    self.label3.text = "updated: " + dateString

                }
                if let watchers = repository.json["watchers_count"].int {
                    self.label4.text = "watchers: " + String(watchers)

                }
            }

        }
    }
    
    // MARK: - ResourceObserver protocol

    func resourceChanged(resource: Resource, event: ResourceEvent) {
        self.updateView()
    }
    
}
