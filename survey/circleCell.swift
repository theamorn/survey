//
//  circleCell.swift
//  survey
//
//  Created by Amorn Apichattanakul on 7/31/16.
//  Copyright © 2016 Nimble. All rights reserved.
//

import UIKit

class circleCell: UITableViewCell {
    
    
    @IBOutlet weak var circle: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.circle.layer.cornerRadius = self.circle.frame.size.width/2
        self.circle.layer.borderWidth = 1.0
        self.circle.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}