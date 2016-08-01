//
//  ViewController.swift
//  survey
//
//  Created by Amorn Apichattanakul on 7/29/16.
//  Copyright © 2016 Nimble. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage

protocol surveyDelegate {
    func takeSurvey(Data dataobject: AnyObject)
}


class ViewController: UIViewController,NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource,surveyDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableIndicator: UITableView!
    
    var lastIndex:NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        fetchingData()
    }
    
    func fetchingData(){
        do{
            print("Fetching Data")
            try self.fetchedController.performFetch()
        } catch {
            print("error fetching Data")
        }
        self.fetchedController.delegate = self
        self.tableIndicator.delegate = self
        
        //if No data in DB
        if(fetchedController.fetchedObjects?.count < 1){
            let api = apiLoader()
            api.getAPI(config.basedAPI) { (jsonData) in
                print("Data Loading Done")
            }
        } else {
            print("data existed")
        }
    }
    
    func initLayout(){
        self.tableView.registerNib(UINib(nibName: "imageSurveyCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableIndicator.registerNib(UINib(nibName: "circleCell", bundle: nil), forCellReuseIdentifier: "circleCell")
    }
    
    lazy var fetchedController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: config.survey)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: ImageIntro.key.title, ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(tableView == self.tableView){
            return tableView.frame.size.height
        } else {
            return 30.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == self.tableView){
            
            let cellIdentifier = "cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? imageSurveyCell
        
            let content = self.fetchedController.objectAtIndexPath(indexPath) as! ImageIntro
        
            cell?.title.text = content.title
            cell?.descriptionTxt.text = content.desc
            cell?.delegate = self
        
            let URL = NSURL(string: content.coverImg!+"l")
            let placeholderImage = UIImage(named: "logo")!
            cell?.headerImg!.af_setImageWithURL(URL!, placeholderImage: placeholderImage)
            
            if(lastIndex != nil){
                let lastCell = self.tableIndicator.cellForRowAtIndexPath(lastIndex!) as! circleCell
                lastCell.circle.backgroundColor = UIColor.clearColor()
                self.lastIndex = indexPath
            }
            
            cell?.index = indexPath
            
            let currentCell = self.tableIndicator.cellForRowAtIndexPath(indexPath) as? circleCell
            currentCell?.circle.backgroundColor = UIColor.whiteColor()

            return cell!
        } else {
            
            let cellIdentifier = "circleCell"
            let circle = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? circleCell
            if (indexPath.row == 0){
                circle?.circle.backgroundColor = UIColor.whiteColor()
                lastIndex = indexPath
            }
            
            return circle!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableView){
            // do nothing
        } else {
            
            let lastCell = tableView.cellForRowAtIndexPath(lastIndex!) as! circleCell
            lastCell.circle.backgroundColor = UIColor.clearColor()
            lastIndex = indexPath

            let cell = tableView.cellForRowAtIndexPath(indexPath) as! circleCell
            cell.circle.backgroundColor = UIColor.whiteColor()
            
            //scroll to position
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    func takeSurvey(Data dataobject: AnyObject) {
        
        self.performSegueWithIdentifier("toDetails", sender:dataobject )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetails" {
            
            print(sender)
           // let indexPath = self.tableView.indexPathForSelectedRow
            let content = fetchedController.objectAtIndexPath(sender as! NSIndexPath) as! ImageIntro
            let destView = segue.destinationViewController as! detailsView
            
            destView.imageString = content.coverImg
            destView.titleString = content.title
            destView.descString = content.desc
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return shareDB.sharedInstance().managedObjectContext
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
        self.tableIndicator.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            self.tableIndicator.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)

            
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            self.tableIndicator.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)

            
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            self.tableIndicator.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)

            
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableIndicator.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)

            
        case .Update:
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! imageSurveyCell
            let content = controller.objectAtIndexPath(indexPath!) as! ImageIntro
            cell.title.text = content.title
            cell.descriptionTxt.text = content.desc
            
            let URL = NSURL(string: content.coverImg!+"l")
            let placeholderImage = UIImage(named: "logo")!
            cell.headerImg.af_setImageWithURL(URL!, placeholderImage: placeholderImage)
            
            let circle = self.tableIndicator.cellForRowAtIndexPath(indexPath!) as! circleCell
            circle.circle.backgroundColor = UIColor.clearColor()
            
            
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
            self.tableIndicator.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableIndicator.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
        self.tableIndicator.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return  UIStatusBarStyle.LightContent
    }
    
    @IBAction func refetchData(sender: UIButton) {
        let db = dbConnect()
        db.clearData()        

        let api = apiLoader()
        api.getAPI(config.basedAPI) { (jsonData) in
            print("Update new Data")
        }
    }


}

