
//  It will convert the current date and time to string.
//


import Foundation

// Today's Date
let rightNow = Date()

//Formatting the date as String in a specific format
func dateAsString()->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d,yyyy h:mm a"
    return dateFormatter.string(from: rightNow)
}

