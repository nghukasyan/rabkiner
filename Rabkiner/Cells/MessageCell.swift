//
//  MessageCell.swift
//  Rabkiner
//
//  Created by MacBook Air on 4/5/19.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {

    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    static let lightGrayColor = UIColor(r: 240, g: 240, b: 240)
    
    let messageTextField: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()
    
    

    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(bubbleView)
        addSubview(messageTextField)
        
        // bubble frame
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        //        bubbleViewLeftAnchor?.active = false
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //messageTextField frame
        messageTextField.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messageTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        messageTextField.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
        
        
        messageTextField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
