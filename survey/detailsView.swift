//
//  detailsView.swift
//  survey
//
//  Created by Amorn Apichattanakul on 7/29/16.
//  Copyright © 2016 Nimble. All rights reserved.
//

import UIKit

class detailsView: UIViewController {
    
    var titleString: String?
    var descString:String?
    var imageString:String?
    
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var descTxt: UILabel!
    @IBOutlet weak var imageHeader: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTxt.text = titleString
        descTxt.text = descString
        
        let URL = NSURL(string: imageString!+"l")
        let placeholderImage = UIImage(named: "logo")!
        imageHeader.af_setImageWithURL(URL!, placeholderImage: placeholderImage)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMain(sender: UIButton) {
        print("back to main")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}