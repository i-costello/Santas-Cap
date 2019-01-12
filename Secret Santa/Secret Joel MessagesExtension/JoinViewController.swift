//
//  JoinViewController.swift
//  Secret Joel MessagesExtension
//
//  Created by Ian Costello on 12/29/18.
//  Copyright © 2018 Bridge. All rights reserved.
//

import UIKit

protocol JoinDelegate {
    func joinGroup(url: URL, joinName: String)
    func getPreviousURL() -> URL?
}

class JoinViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var EmptyFieldWarning: UILabel!
    
    var previousURL: URL?
    
    var delegate:JoinDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkUIColor,
            NSAttributedString.Key.font : UIFont(name: "Futura", size: 14)!]
        NameInput.attributedPlaceholder = NSAttributedString(string: "Your Name Here", attributes:attributes)
        NameInput.setLeftPaddingPoints(5)
        
        EmptyFieldWarning.isHidden = true
        self.NameInput.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func joinGroup(_ sender: Any) {
        previousURL = getPreviousURL(self)
        if NameInput.text != "" {
            NameInput.text = NameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            delegate?.joinGroup(url: previousURL!, joinName: NameInput.text!)
        }
        else
        {
            handleEmptyField()
        }
    }
    
    func getPreviousURL(_ sender: Any) -> URL? {
        return delegate?.getPreviousURL()
    }
    
    func handleEmptyField() {
        EmptyFieldWarning.isHidden = false
        self.EmptyFieldWarning.transform = CGAffineTransform(translationX: 3, y: 0)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 20, options: .allowUserInteraction, animations: {
            self.EmptyFieldWarning.isHidden = false
            self.EmptyFieldWarning.transform = .identity
        })
        print("Field(s) empty!!")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
