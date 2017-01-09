//
//  checkBox.swift
//  market
//
//  Created by Jose Duin on 1/9/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit

class checkBox: UIButton {

    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
                self.tintColor = UIColor(red:255/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1)
            } else {
                self.setImage(uncheckedImage, for: .normal)
                self.tintColor = UIColor.lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(checkBox.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
        self.tintColor = UIColor.lightGray
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
