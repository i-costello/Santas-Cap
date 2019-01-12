//
//  ResultsViewController.swift
//  Secret Joel MessagesExtension
//
//  Created by Ian Costello on 1/2/19.
//  Copyright © 2019 Bridge. All rights reserved.
//

import UIKit

protocol ResultsDelegate {
    func getPreviousURL() -> URL?
    func getLocalUUIDString() -> String
    func parseURL() -> [String:String]?
}

class ResultsViewController: UIViewController {

    var assignedPartner: String = ""
    var url: URL?
    var localUUID: String = ""
    var delegate:ResultsDelegate?
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        url = getPreviousURL(self)
        if let urlContents = parseURL(self) {
            localUUID = getLocalUUIDString(self)
            
            resultLabel.text = "You'll be buying a gift for \(findPartner(localUUID: localUUID, urlContents: urlContents))!"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func findPartner(localUUID: String, urlContents: [String:String]) -> String {
        var partnerUUID = ""
        var shouldParse = false
        for character in urlContents[localUUID] ?? "" {
            if character == ":" && !shouldParse {
                shouldParse = true
            }
            else if shouldParse {
                partnerUUID += String(character)
            }
        }
        
        shouldParse = true
        var result = ""
        for character in urlContents[partnerUUID] ?? "" {
            if character == ":" {
                shouldParse = false
            }
            else if shouldParse {
                result += String(character)
            }
        }
        return result
    }
    
    
    func getPreviousURL(_ sender: Any) -> URL? {
        return delegate?.getPreviousURL()
    }

    func getLocalUUIDString(_ sender: Any) -> String {
        return (delegate?.getLocalUUIDString())!
    }
    
    func parseURL(_ sender: Any) -> [String:String]? {
        return delegate?.parseURL()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
