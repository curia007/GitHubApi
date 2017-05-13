//
//  ViewController.swift
//  GithubClient
//
//  Created by Carmelo I. Uria on 5/11/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import UIKit
import GithubServices

class DifferenceWebViewController: UIViewController
{
    var number : String?
    
    private let githubService : GithubService = GithubService()
    
    private let queue: OperationQueue = OperationQueue()
    private var pullRequest: Any?
    private var files: Any?
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //githubService.retrievePullRequest("magicalpanda", repos: "MagicalRecord", number: 1228)
        //githubService.retrievePullRequestFileChanges("magicalpanda", repos: "MagicalRecord", number: 1228)
    
        //let url : URL = URL(string: "https://github.com/magicalpanda/MagicalRecord/pull/1228/files")!
        //let request: URLRequest = URLRequest(url: url)
        //self.webView.loadRequest(request)

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
                
                debugPrint("[\(#function)] files: \(String(describing: self.files))")
            }
            
            
        })

    }

    override func viewWillAppear(_ animated: Bool)
    {
        // Display NavigationBar
        self.title = "Diffs for Number \(number!)"
        
        guard let urlString : String =  "https://github.com/magicalpanda/MagicalRecord/pull/\(number!)/files" else
        {
            return
        }
        
        let url : URL = URL(string: urlString)!
        
        let request : URLRequest = URLRequest(url: url)
        self.webView.loadRequest(request)
        
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

