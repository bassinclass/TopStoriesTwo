//
//  ViewController.swift
//  TopStoriesTwo
//
//  Created by Fleischauer, Joseph on 9/30/18.
//  Copyright © 2018 Fleischauer, Joseph. All rights reserved.
//

import UIKit

class SourcesViewController: UITableViewController {
    
    var sources = [[String: String]]()
    var apiKey = "679376b10aad42019ff49513ad555602"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News Sources"
        let query = "https://newsapi.org/v1/sources?languages=en&country=us&apiKey=\(apiKey)"
       DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    if json["status"] == "ok" {
                        self.parse(json: json)
                        return
                    }
                }
            }
        self.loadError()
        }
    }
    
    func parse(json: JSON) {
        for result in json["sources"].arrayValue {
            let id = result["id"].stringValue
            let name = result["name"].stringValue
            let description = result["description"].stringValue
            let source = ["id" : id, "name" : name, "description" : description]
            sources.append(source)
        }
        DispatchQueue.main.async { //students will need help identifying where to call dispatch queue closure.
            [unowned self] in
              self.tableView.reloadData()
        }
    }
    
    func loadError() {
        let alert = UIAlertController(title: "loading error", message: "there was a problem loading the news feed", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID Cell", for: indexPath)
        let source = sources[indexPath.row]
        cell.textLabel?.text = source["name"]
        cell.detailTextLabel?.text = source["description"]
        return cell
    }
    
    @IBAction func onDoneButtonTapped(_ sender: UIBarButtonItem) {
        exit(0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ArticlesViewController
        let index = tableView.indexPathForSelectedRow?.row
        dvc.source = sources[index!]
        dvc.apiKey = apiKey
    }
    
    
}






