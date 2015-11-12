//
//  ChallengesTableViewController.swift
//  SiestaRealmIntegration
//
//  Created by Annica Burns on 11/1/15.
//

import UIKit
import Siesta

class TableViewController: UITableViewController, ResourceObserver {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var statusOverlay = ResourceStatusOverlay()
    
    var userList: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            userList?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    var repoList: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            repoList?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusOverlay.embedIn(self)
        
        self.userList = GitHubAPI.user()
        self.repoList = GitHubAPI.userRepos()

    }
    
    override func viewDidLayoutSubviews() {
        statusOverlay.positionToCover(self.view)
    }
    
    // MARK: - Functions
    
    func updateHeaderView() {
        if let user = userList?.userArray.first {
            self.usernameLabel.text = user.login
            self.fullNameLabel.text = user.name
        } else {
            self.usernameLabel.text = ""
            self.fullNameLabel.text = ""
        }

    }


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoList?.repositoryArray.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        if let cell = cell as? RepositoryTableViewCell, let repoList = repoList {
            let repo = repoList.repositoryArray[indexPath.row]
            cell.repoLabel.text = repo.full_name
        }


        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDetail", sender: self)
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController,
        let selectedIndexPath = self.tableView.indexPathForSelectedRow,
        let repoList = repoList {
            let repo = repoList.repositoryArray[selectedIndexPath.row]
            vc.repoList = GitHubAPI.repo(repo.full_name)
        }
    }
    
    // Siesta ResourceObserver Delegate
    
    func resourceChanged(resource: Resource, event: ResourceEvent) {
        self.tableView.reloadData()
        self.updateHeaderView()
    }

}

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var repoLabel: UILabel!
}


