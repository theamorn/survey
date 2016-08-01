//
//  imageSurveyCell.swift
//  survey
//
//  Created by Amorn Apichattanakul on 7/29/16.
//  Copyright © 2016 Nimble. All rights reserved.
//

import UIKit

class imageSurveyCell: UITableViewCell {
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionTxt: UILabel!
    @IBOutlet weak var surveyBtn: UIButton!
    
    @IBOutlet weak var gradientView: UIView!
    
    var delegate:surveyDelegate!
    var index:NSIndexPath?

    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.surveyBtn.layer.cornerRadius = 20
        
        gradientLayer.frame = gradientView.bounds
        let topColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0)
        let bottomColor = UIColor.init(red: 22.0/255.0, green: 29.0/255.0, blue: 37.0/255.0, alpha: 0.7)
        gradientLayer.colors = [bottomColor.CGColor, topColor.CGColor]
        
        gradientView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        self.gradientLayer.frame = gradientView.bounds
    }
    
    @IBAction func takeSurvey(sender: UIButton) {
        if(self.delegate != nil){
            self.delegate.takeSurvey(Data: index!)
        }
    }
    
}