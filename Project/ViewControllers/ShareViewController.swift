//
//  ShareViewController.swift
//  Project


import UIKit
import Social
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit
class ShareViewController: UIViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var post : UILabel!
    let image : UIImage = UIImage(named: "space1.jpg")!
    var finalScore : Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        post.text = "My final score is " + String(mainDelegate.mainScore)
    }
    
    
    @IBAction func shareTwitter(sender: UIButton){
        let tweetText = post.text
        let tweetUrl = "https://www.crazygames.com/game/space-battle/"
        
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        UIApplication.shared.openURL(url!)
        
    }
   
    // This was achieved by installing cocoa pods, creating facebook developers account and installing the required frameworks like FBSDKShareKit, FBSDKLoginKit, FBSDKCoreKit.
    @IBAction func shareTextOnFaceBook(sender: UIButton) {
        let content = ShareLinkContent()
        
        content.contentURL =  URL(string: "https://www.crazygames.com/game/space-battle/")!
        content.quote = post.text
        let dialog : ShareDialog = ShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = ShareDialog.Mode.automatic
        dialog.show()
    }
    
}

