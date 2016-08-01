//
//  ImageIntro.swift
//  
//
//  Created by Amorn Apichattanakul on 7/29/16.
//
//

import Foundation
import CoreData


class ImageIntro: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    struct key  {
        static let title = "title"
        static let desc = "description"
        static let coverImg = "cover_image_url"
        
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject],context:NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName(config.survey, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        title = dictionary[key.title] as? String
        desc = dictionary[key.desc] as? String
        coverImg = dictionary[key.coverImg] as? String
    }


}
