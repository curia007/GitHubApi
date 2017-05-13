//
//  GitHubClientViewController.swift
//  GithubClient
//
//  Created by Carmelo I. Uria on 5/12/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import UIKit
import GithubServices

class GitHubClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!

    private let service : GithubService = GithubService()
    
    private let queue: OperationQueue = OperationQueue()
    
    private var pullRequests : [Any] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        service.retrievePullRequests("magicalpanda", repos: "MagicalRecord")
        
        // the alert view
        //let alert = UIAlertController(title: "", message: "Loading Pull Requests", preferredStyle: .alert)
        //self.present(alert, animated: true, completion: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST), object: nil, queue: self.queue, using: { (notification) -> Void in
            
            if (notification.object != nil)
            {
                self.pullRequests = notification.object as! [Any]
                DispatchQueue.main.async(execute: {self.tableView.reloadData()})
            }
            
          //  alert.dismiss(animated: true, completion: nil)
        })
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        debugPrint("[\(#function)] segue identifier: \(String(describing: segue.identifier))")
        
        if (segue.identifier == "PullRequestFilesSegueIdentifier")
        {
            let cell : UITableViewCell = sender as! UITableViewCell
            let indexPath : IndexPath = self.tableView.indexPath(for: cell)!
            let pullRequest : [String : Any] = self.pullRequests[indexPath.row] as! [String : Any]
            
            let number : Int32 = pullRequest["number"] as! Int32
            service.retrievePullRequest("magicalpanda", repos: "MagicalRecord", number: number)
            
            let destination : DifferenceWebViewController = segue.destination as! DifferenceWebViewController
            destination.number = String(number)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return pullRequests.count
    }
    
    // MARK: - TableViewDelegate methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PullRequestCellIdentifier", for: indexPath)
        
        // Configure the cell...
        let pullRequest : [String : Any] = self.pullRequests[indexPath.row] as! [String : Any]
        let user : [String : Any] = pullRequest["user"] as! [String : Any]
        
        cell.textLabel?.text = pullRequest["title"] as? String
        cell.detailTextLabel?.text = user["login"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        debugPrint("[\(#function)]")
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

}
