//
//  CompactViewController.swift
//  Secret Joel MessagesExtension
//
//  Created by Ian Costello on 12/23/18.
//  Copyright © 2018 Bridge. All rights reserved.
//

import UIKit

protocol CompactDelegate {
    func startGroup()
}

class CompactViewController: UIViewController {
    @IBOutlet weak var StartGroupButton: UIButton!
    
    @IBOutlet weak var HelpButton: UIButton!
    @IBOutlet var HelpMenu: UIView!
    @IBOutlet weak var PatternView: UIView!
    var delegate:CompactDelegate?
    @IBOutlet weak var HelpTextView: UITextView!
    
    @IBOutlet var TransitionView: UIView!
    
    var helpAnimateX: CGFloat = 0.0
    var helpAnimateY: CGFloat = 0.0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StartGroupButton.imageView?.layer.cornerRadius = 20
        StartGroupButton.layer.cornerRadius = 20
        StartGroupButton.layer.masksToBounds = true
        StartGroupButton.imageView?.layer.masksToBounds = true
        
        var snowflakePic = UIImage(named: "Snowflakes-1")
        let snowScale = (snowflakePic?.size.width)!*3/(HelpTextView.frame.size.width)
        snowflakePic = UIImage(cgImage: (snowflakePic?.cgImage)!, scale: snowScale, orientation: UIImage.Orientation.up)
        PatternView.backgroundColor = UIColor(patternImage: snowflakePic!)
        
        HelpTextView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        var width = view.frame.size.width
        var height = view.frame.size.height
        
        var frame = CGRect(x:0, y:0, width: width * 0.9, height: height * 0.8)
        HelpMenu.frame = frame

        if HelpMenu.isDescendant(of: view) {
            let safeFrame = view.safeAreaLayoutGuide.layoutFrame
            width = safeFrame.size.width
            height = safeFrame.size.height
            
            let centerX = view.safeAreaInsets.left + 0.5*safeFrame.width
            let centerY = view.safeAreaInsets.top + 0.5*safeFrame.height
            frame = CGRect(x: centerX - 0.5*0.9*width, y: centerY - 0.5*0.8*height, width: width * 0.9, height: height * 0.7)
            HelpMenu.frame = frame
            
            helpAnimateX = HelpButton.center.x - HelpMenu.frame.origin.x - HelpMenu.frame.width
            helpAnimateY = HelpButton.center.y - HelpMenu.frame.origin.y
            self.HelpMenu.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.125, animations: {
                self.HelpButton.transform = CGAffineTransform(translationX: (self.helpAnimateX), y: -(self.helpAnimateY))
                self.HelpMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        else if TransitionView.isDescendant(of: view) {
            let safeFrame = view.safeAreaLayoutGuide.layoutFrame
            TransitionView.frame = safeFrame
            UIView.animate(withDuration: 0.75, animations: { self.TransitionView.backgroundColor = UIColor.black.withAlphaComponent(1)})
        }
    }

    @IBAction func startSSGroup(_ sender: Any) {
        delegate?.startGroup()
        TransitionView.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.addSubview(TransitionView)
    }
    
    @IBAction func openHelp(_ sender: Any) {
        setHelpText()
        if HelpMenu.isDescendant(of: view) {
            HelpMenu.removeFromSuperview()
            HelpButton.setTitle("?", for: .normal)
            UIView.animate(withDuration: 0.125, animations: {
                self.HelpButton.transform = CGAffineTransform(translationX: -(self.helpAnimateX), y: (self.helpAnimateY))})
            helpAnimateX = 0.0
            helpAnimateY = 0.0
        }
        else {
            view.addSubview(HelpMenu)
            view.bringSubviewToFront(HelpButton)
            HelpButton.setTitle("x", for: .normal)
        }
    }
    
    func setHelpText() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let mainHeadingAttr = [NSAttributedString.Key.font: UIFont(name:"Futura-bold", size: 20)!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.baselineOffset: 8, NSAttributedString.Key.paragraphStyle: paragraph] as [NSAttributedString.Key : Any]
        let subHeadingAttr = [NSAttributedString.Key.font: UIFont(name:"Futura", size:16)!, NSAttributedString.Key.baselineOffset: 3] as [NSAttributedString.Key : Any]
        let bodyTextAttr = [NSAttributedString.Key.font: UIFont(name: "Futura", size: 12)!]
        
        let help = NSMutableAttributedString(string: "Help\n", attributes: mainHeadingAttr)
        let about = NSMutableAttributedString(string: "About\n", attributes: subHeadingAttr)
        let aboutText = NSMutableAttributedString(string: "Santa's Cap is a tool I made to help my friends and I assign partners for a Secret Santa event remotely. In person, you can pick names out of a hat, with no one knowing who their Secret Santa is. But that's hard to do online... without Santa's Cap.\n\n", attributes: bodyTextAttr)
        let SSAssignerTool = NSMutableAttributedString(string: "Secret Santa Assignment Tool\n", attributes: subHeadingAttr)
        let SSATText = NSMutableAttributedString(string: "To pick names\"from a hat\" tap the \"Create a Group\" button (look for Santa's face)...\n", attributes: bodyTextAttr)
        
        let santaPic = NSTextAttachment()
        santaPic.image = UIImage(named: "SS Button-1")
        let scaleFactor = (santaPic.image?.size.width)!*5/(HelpTextView.frame.size.width)
        santaPic.image = UIImage(cgImage: (santaPic.image?.cgImage)!, scale: scaleFactor, orientation: UIImage.Orientation.up)
        let santaPicString = NSMutableAttributedString(attachment: santaPic)
        santaPicString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: 1))
        
        let SSATText2 = NSMutableAttributedString(string: "\n...fill out the group-invitation details, and tap the \"Send the Invite!\" button.\n", attributes: bodyTextAttr)
        
        let invitePic = NSTextAttachment()
        invitePic.image = UIImage(named: "Send Button-1")
        let scaleFactor2 = (invitePic.image?.size.width)!*3/(HelpTextView.frame.size.width)
        invitePic.image = UIImage(cgImage: (invitePic.image?.cgImage)!, scale: scaleFactor2, orientation: UIImage.Orientation.up)
        let invitePicString = NSMutableAttributedString(attachment: invitePic)
        invitePicString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: 1))
        
        let SSATText3 = NSMutableAttributedString(string: "\nYour friends will receive a message, and can accept the invite by entering their name. Finally, once the group is full, tap the message bubble to get your results. Santa's Cap will tell you who to buy a gift for!\n\n", attributes: bodyTextAttr)
        let planner = NSMutableAttributedString(string: "Planner (Coming Soon)\n", attributes: subHeadingAttr)
        let plannerText = NSMutableAttributedString(string: "I'm working on a scheduling tool (my group desperately needed one), which lets everyone in your group chat fill out an availability calendar. Once everyone has filled it out, it will find a date that works for the most people.\n\n", attributes: bodyTextAttr)
        let contact = NSMutableAttributedString(string: "Contact Me\n", attributes: mainHeadingAttr)
        let contactText = NSMutableAttributedString(string: "If you have any bugs, issues, or inquiries, don't hesitate to let me know!\n\nEmail: ", attributes: bodyTextAttr)
        let email = NSMutableAttributedString(string: "santascap@gmail.com", attributes: bodyTextAttr)
        email.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: 19))
        
        let result:NSMutableAttributedString = help
        result.append(about)
        result.append(aboutText)
        result.append(SSAssignerTool)
        result.append(SSATText)
        result.append(santaPicString)
        result.append(SSATText2)
        result.append(invitePicString)
        result.append(SSATText3)
        result.append(planner)
        result.append(plannerText)
        result.append(contact)
        result.append(contactText)
        result.append(email)
        
        HelpTextView.attributedText = result
        self.HelpTextView.scrollRangeToVisible(NSMakeRange(0, 1))
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
