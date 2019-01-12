//
//  ExpandedViewController.swift
//  Secret Joel MessagesExtension
//
//  Created by Ian Costello on 12/23/18.
//  Copyright © 2018 Bridge. All rights reserved.
//

import UIKit

protocol ExpandedDelegate {
    func sendInvite(groupName:String, groupSize:Int, date:String, organizerName:String)
}

extension UIColor {
    static let darkUIColor = UIColor(red: 176/255, green: 104/255, blue: 125/255, alpha: 1)
}

class ExpandedViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var SSGroupName: UITextField!
    @IBOutlet weak var NumberParticipants: UITextField!
    @IBOutlet weak var ChosenDate: UITextField!
    @IBOutlet weak var OrganizerName: UITextField!
    
    @IBOutlet weak var EmptyFieldWarning: UILabel!
    
    @IBOutlet var TransitionView: UIView!
    
    private var datePicker: UIDatePicker!
    
    var delegate:ExpandedDelegate?
    
    override func viewDidLoad() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkUIColor,
            NSAttributedString.Key.font : UIFont(name: "Futura", size: 14)!]
        SSGroupName.attributedPlaceholder = NSAttributedString(string: "Secret Santa Group", attributes:attributes)
        NumberParticipants.attributedPlaceholder = NSAttributedString(string: "# People", attributes:attributes)
        ChosenDate.attributedPlaceholder = NSAttributedString(string: "MM/DD/YY", attributes:attributes)
        OrganizerName.attributedPlaceholder = NSAttributedString(string: "Your Name Here", attributes:attributes)
        SSGroupName.setLeftPaddingPoints(5)
        NumberParticipants.setLeftPaddingPoints(5)
        ChosenDate.setLeftPaddingPoints(5)
        OrganizerName.setLeftPaddingPoints(5)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        ChosenDate.inputView = datePicker
        
        EmptyFieldWarning.isHidden = true
        self.SSGroupName.delegate = self
        self.OrganizerName.delegate = self
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TransitionView.backgroundColor = UIColor.black.withAlphaComponent(1)
        view.addSubview(TransitionView)
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        TransitionView.frame = safeFrame
        UIView.animate(withDuration: 0.5, animations: { self.TransitionView.backgroundColor = UIColor.black.withAlphaComponent(0)}, completion: { (value: Bool) in self.TransitionView.removeFromSuperview()})
        

        super.viewDidAppear(true)
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        ChosenDate.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    

    @IBAction func sendInvite(_ sender: Any) {
        if SSGroupName.text != "" && NumberParticipants.text != "" && ChosenDate.text != "" && OrganizerName.text != "" {
            SSGroupName.text = SSGroupName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            OrganizerName.text = OrganizerName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            delegate?.sendInvite(groupName: SSGroupName.text!, groupSize: Int(NumberParticipants.text!)!, date: ChosenDate.text!, organizerName: OrganizerName.text!)
        }
        else {
            handleEmptyField()
        }
    }
    
    func handleEmptyField() {
        self.EmptyFieldWarning.transform = CGAffineTransform(translationX: 3, y: 0)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 20, options: .allowUserInteraction, animations: {
            self.EmptyFieldWarning.isHidden = false
            self.EmptyFieldWarning.transform = .identity
        })
        EmptyFieldWarning.isHidden = false
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
