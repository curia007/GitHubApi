//
//  GithubClientTableViewController.swift
//  GithubClient
//
//  Created by Carmelo I. Uria on 5/11/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import UIKit
import GithubServices

class GithubClientTableViewController: UITableViewController
{

    private let service : GithubService = GithubService()
    
    private let queue: OperationQueue = OperationQueue()
    
    private var pullRequests : [Any] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
                
        service.retrievePullRequests("magicalpanda", repos: "MagicalRecord")
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST), object: nil, queue: self.queue, using: { (notification) -> Void in
            
            if (notification.object != nil)
            {
                self.pullRequests = notification.object as! [Any]
                self.tableView.reloadData()
            }
        })
    
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.pullRequests.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    // MARK: - TableViewDelegate methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PullRequestCellIdentifier", for: indexPath)

        // Configure the cell...
        let pullRequest : [String : Any] = self.pullRequests[indexPath.row] as! [String : Any]
        let user : [String : Any] = pullRequest["user"] as! [String : Any]
        
        cell.textLabel?.text = pullRequest["title"] as? String
        cell.detailTextLabel?.text = user["login"] as? String

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
     {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) 
     {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) 
     {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool 
     {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
     {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}