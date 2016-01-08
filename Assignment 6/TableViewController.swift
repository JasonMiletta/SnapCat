//
//  ViewController.swift
//  Assignment 6
//
//  Created by Jason Michael Miletta on 3/11/15.
//  Copyright (c) 2015 Jason Michael Miletta. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var nameList: [String] = ["Ron", "John", "Don", "Juan"]
    var imageList: [String] = ["Cat1.jpg", "Cat2.jpg", "Cat3.jpg", "Cat4.jpg"]
    
    var currentDateVal = NSDate()
    var snapList: [(name: String, date: String, imageSrc: String)] = []
    
    var screenBounds = UIScreen.mainScreen().bounds
    var imageView: UIImageView! = UIImageView()
    var timerImageView: UIImageView! = UIImageView()
    
    var timer: NSTimer = NSTimer()
    
    var countdownLabel: UILabel! = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backgroundLabel: UILabel! = UILabel()
        backgroundLabel.text = "You have no Snapchats. Swipe down to refresh"
        backgroundLabel.numberOfLines = 0
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundView = backgroundLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let refresher = UIRefreshControl()
        refresher.backgroundColor = UIColor.grayColor()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snapList.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        return snapList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MyCell
        
        cell.setup(snapList[indexPath.row])
        
        return cell
    }
    
    func formatDateToString(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, YYY - h:mm a"
        return formatter.stringFromDate(date)
    }
    
    func refresh (){
        let _ = NSTimer.scheduledTimerWithTimeInterval(
            3.0,
            target: self,
            selector: "refreshCompleted",
            userInfo: nil,
            repeats: false
        )
    }
    
    func refreshCompleted() {
        let newSnap: (name: String, date: String, imageSrc: String) = generateNewSnap()
        var newSnapList = [newSnap]
        newSnapList += snapList
        snapList = newSnapList
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
        //Set text for refreshControl
        let attributes = NSDictionary(
            object: UIColor.greenColor(),
            forKey: NSForegroundColorAttributeName
        )
        
        let date = NSDate()
        let lastUpdated: String = "Last Updated: " + formatDateToString(date)
        
        let string = NSAttributedString(string: lastUpdated, attributes: attributes as! [String : AnyObject])
        self.refreshControl?.attributedTitle = string
        
    }
    
    func generateNewSnap() -> (String, String, String){
        let name = nameList[random() % nameList.count]
        let image = imageList[random() % imageList.count]
        
        currentDateVal = currentDateVal.dateByAddingTimeInterval(NSTimeInterval((random() % 1000000)))
        
        return (name, formatDateToString(currentDateVal), image)
    }
    
    //TODO
    @IBAction func showSnap (recognizer: UILongPressGestureRecognizer){
        
        if recognizer.state == UIGestureRecognizerState.Began{
            let location = recognizer.locationInView(self.tableView)
            let index = self.tableView.indexPathForRowAtPoint(location)
            if (index != nil){
                
                imageView.bounds = screenBounds
                
                //var imageSource = snapList[index].imageSrc
                let imageSource = imageList[random() % imageList.count]
                imageView.image = UIImage(named: imageSource)
                imageView.frame = CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                
                self.tableView.addSubview(imageView)
                
                //Add timer
                timerImageView.frame = CGRect(x: UIScreen.mainScreen().bounds.width - 40, y: 10, width: 30, height: 30)
                timerImageView.backgroundColor = UIColor.grayColor()
                self.imageView.addSubview(timerImageView)
                
                timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "removeImage", userInfo: nil, repeats: false)
            }
        }
        else{
            //call the view's removeFromSuperview
            imageView.removeFromSuperview()
            timer.invalidate()
        }
    }
    
    func removeImage() {
        imageView.removeFromSuperview()
    }
    
    
}

