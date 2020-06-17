//
//  ListTableViewCell.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

   
        
        @IBOutlet weak var cellImage: UIImageView!
        @IBOutlet weak var cellNameLabel: UILabel!
        @IBOutlet weak var cellURLLabel: UILabel!
        
        
        
        func setCellInfo(studentName: String, studentURL: String) {
            
            cellImage.image = UIImage(named: "pngwave")!
            cellNameLabel.text = studentName
            cellURLLabel.text = studentURL
        }
    
}
