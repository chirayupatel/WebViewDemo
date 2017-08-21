//
//  CallbacksViewController.swift
//  WebViewDemo
//
//  Created by Chirayu-Flybits on 2017-08-18.
//  Copyright © 2017 Flybits. All rights reserved.
//

import Foundation
import UIKit

class CallbacksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Javascript callback messages to display in table view
    var items : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto scale table view cell row height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    // Hides status bar for this view controller
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func doneClicked(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        let text = items[indexPath.row]

        // Handle displaying multi-line text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
       
        cell.textLabel?.text = text
        
        return cell
    }
    
}
