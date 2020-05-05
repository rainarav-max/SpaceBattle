//
//  PlayerData.swift
//  Project


import UIKit

class PlayerData: NSObject {
    var id : Int?
    var name : String?
    
    func initWithData(theRow i : Int, theName n : String) {
        id = i
        name = n
    }
}
