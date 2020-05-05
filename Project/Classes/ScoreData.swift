
import UIKit

class ScoreData: NSObject {
    
    var scoreId : Int?
    var score : Int?
    var date : String?
    var image : String?
    
    func initWithData(theRow i : Int, theScore s : Int, theDate d : String, theImage img : String) {
        scoreId = i
        score = s
        date = d
        image = img
    }
}
