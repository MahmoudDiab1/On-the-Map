//
//  ListViewController.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class ListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
   
    
    @IBOutlet weak var ListTableView: UITableView!
    var result = [Location]()

  
  override func viewWillAppear(_ animated: Bool) {
       
      self.ListTableView.reloadData()
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationClient.getLocationsOrdered(completion: handleStudentInfo(result:))
       
        
    }
    
    
    func handleStudentInfo(result:Result<[Location], Error>){
        
        switch result {
        case .success(let studentInfo):
            self.result = studentInfo
            self.ListTableView.reloadData()
            
        case .failed(let error):
            print("HANDLE ERROR BY ALERT\(error)")
        }
        
        print(StudentTableView.student)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
           let student = result[indexPath.row]
           let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! ListTableViewCell
        cell.setCellInfo(studentName: student.firstName, studentURL: student.mediaURL)
            print( StudentTableView.student)
           return cell
       }
}
