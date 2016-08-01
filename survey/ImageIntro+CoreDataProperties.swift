//
//  ImageIntro+CoreDataProperties.swift
//  
//
//  Created by Amorn Apichattanakul on 7/29/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageIntro {

    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var coverImg: String?

}
