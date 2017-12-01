//
//  DetailsViewController.swift
//  GitAPI
//
//  Created by Tharun on 01/12/17.
//  Copyright © 2017 Tharun. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var repositoriesList: [[String: AnyObject]]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let repository = repositoriesList[indexPath.row]
        cell.textLabel?.text = repository["name"] as? String
        cell.detailTextLabel?.text = repository["html_url"] as? String
        return cell
    }
    
}
