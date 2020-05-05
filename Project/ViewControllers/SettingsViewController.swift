//
//  SettingsViewController.swift
//  Project


import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    //the main delegate
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var sgDiff : UISegmentedControl!
    @IBOutlet var volSlider: UISlider!
    @IBOutlet var tName : UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    //event listener for difficulty picker
    @IBAction func segementDidChange(sender: UISegmentedControl){
        updateDifficulty()
    }
    
    //event listener for volumeslider
    @IBAction func volumeDidChange(sender: UISlider){
        mainDelegate.volumeLevel = sender.value
    }
    
    //to update the difficulty level in the appdelegate which can be accessed in the gamescene
    func updateDifficulty(){
        let diff = sgDiff.selectedSegmentIndex
        print("Difficulty changed to: \(diff)")

        if diff == 0 {
            mainDelegate.difficultyLevel = 0
        }else if diff == 1 {
            mainDelegate.difficultyLevel = 1
        }else if diff == 2{
            mainDelegate.difficultyLevel = 2
        }else{
            print("Unknown difficulty found!!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.readNameFromDatabase()
        tName.text = mainDelegate.playerName?.name
        //setting the value of segmented control to reflect the saved change
        sgDiff.selectedSegmentIndex = mainDelegate.difficultyLevel
        
        //to make volSlider reflect the value saved in app delegate
        volSlider.value = mainDelegate.volumeLevel
    }

}
