//
//  ListTableViewCell.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    // MARK:- outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var mediaUrl: UILabel!
    
    // Configure Cell.
    func setCellInfo(studentName: String , mediaUrl:String){
        self.cellNameLabel.text = studentName
        self.mediaUrl.text = mediaUrl
    }
    
}
