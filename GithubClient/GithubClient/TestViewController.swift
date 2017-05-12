//
//  ViewController.swift
//  GithubClient
//
//  Created by Carmelo I. Uria on 5/11/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import UIKit
import GithubServices

class TestClientViewController: UIViewController
{
    let githubService : GithubService = GithubService()

    private let queue: OperationQueue = OperationQueue()
    private var pullRequest: Any?
    private var files: Any?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        githubService.retrievePullRequest("magicalpanda", repos: "MagicalRecord", number: 1228)
        githubService.retrievePullRequestFileChanges("magicalpanda", repos: "MagicalRecord", number: 1228)
     
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST_BY_NUMBER), object: nil, queue: self.queue, using: { (notification) -> Void in
            
            if (notification.object != nil)
            {
                self.pullRequest = notification.object
           
                debugPrint("[\(#function)] pull request:  \(String(describing: self.pullRequest))")
            }

            
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST_FILES), object: nil, queue: self.queue, using: { (notification) -> Void in
            
            if (notification.object != nil)
            {
                self.files = notification.object
                
                debugPrint("[\(#function)] pull request:  \(String(describing: self.pullRequest))")
            }
            
            
        })

    }

    override func viewWillAppear(_ animated: Bool)
    {
        // Display NavigationBar
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

