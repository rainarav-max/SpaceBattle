//
//  ScoreHistoryViewController.swift
//  Project


import UIKit

class ScoreHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.player.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: .default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        let img = mainDelegate.player[rowNum].image
        tableCell.myImageView.image = UIImage(named: img!)
        tableCell.primaryLabel.text = "Score: " + String(mainDelegate.player[rowNum].score!)
        tableCell.secondaryLabel.text = mainDelegate.player[rowNum].date
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainDelegate.readDataFromDatabase()
    }
   
}
