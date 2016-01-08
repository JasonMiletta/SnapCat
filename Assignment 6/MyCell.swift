//
//  MyCell.swift
//  Assignment 6
//
//  Created by Jason Michael Miletta on 3/12/15.
//  Copyright (c) 2015 Jason Michael Miletta. All rights reserved.
//

import UIKit

class MyCell : UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var imageString: String = ""
    
    func setup(snapTuple :(name: String, date: String, imageSrc: String)){
        nameLabel.text = snapTuple.name
        dateLabel.text = snapTuple.date
        imageString = snapTuple.imageSrc
    }
    
}
