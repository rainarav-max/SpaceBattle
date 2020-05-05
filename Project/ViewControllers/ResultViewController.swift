//
//  ResultViewController.swift
//  Project


import UIKit

class ResultViewController: UIViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var currentScore : UILabel!
    @IBOutlet var highScore : UILabel!
    var category : String = "Noobie"
    let rightNow = dateAsString()
    
    func scoreCategory(){
        if Int(currentScore.text!)! < 50{
            category = "Noobie"
        }
        else if Int(currentScore.text!)! < 100 && Int(currentScore.text!)! >= 50 {
            category = "Intermediate"
        }
        else{
            category = "Pro"
        }
    }
    
    func addScore() {
        scoreCategory()
        let score : ScoreData = ScoreData.init()
        score.initWithData(theRow: 0, theScore: Int(currentScore.text!)!, theDate: rightNow, theImage: category+".png")
        let returnCode = mainDelegate.insertIntoDatabase(player: score)
        
        if returnCode == false {
            print("Score add failed")
        }
        else{
            print("Score Added")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.getHighScore()
        highScore.text = String(mainDelegate.player[0].score!)
        currentScore.text = String(mainDelegate.mainScore)
    }
    
    @IBAction func unwindToResultPageVC(sender: UIStoryboardSegue){
        
    }
    
    
}
