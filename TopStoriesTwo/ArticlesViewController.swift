//
//  ViewController.swift
//  TopStoriesTwo
//
//  Created by Fleischauer, Joseph on 9/30/18.
//  Copyright © 2018 Fleischauer, Joseph. All rights reserved.
//

import UIKit

class ArticlesViewController: UITableViewController {
    
    var articles = [[String: String]]()
    var apiKey = ""
    var source = [String: String] ()
    
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
        for result in json["articles"].arrayValue {
            let title = result["title"].stringValue
            let description = result["description"].stringValue
            let url = result["url"].stringValue
            let article = ["title": title, "description": description, "url": url]
            articles.append(article)
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
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID Cell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["title"]
        cell.detailTextLabel?.text = article["description"]
        return cell
    }
    
}






