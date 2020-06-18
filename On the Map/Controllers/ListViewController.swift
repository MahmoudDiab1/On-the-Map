//
//  ListViewController.swift
//  On the Map
//
//  Created by mahmoud diab on 6/17/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class ListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    // MARK:- Outlets
    @IBOutlet weak var ListTableView: UITableView!
    
    
    
    // MARK:- Instances
    var result = [StudentInformation ]()
    
    
    
    // MARK:- LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.ListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListTableView.delegate = self
        ListTableView.dataSource = self
        LocationClient.getLocationsOrdere(completion: handleStudentInfo(result:))
    }
    
    
    // MARK:- Actions
    // Add new student location.
    @IBAction func addPressed(_ sender: Any) {
        guard let NavController = storyboard?.instantiateViewController(identifier: "NavController") as? NavController else { return }
        NavController.modalPresentationStyle = .fullScreen
        NavController.modalTransitionStyle = .flipHorizontal
        present(NavController,animated: true,completion: nil)
    }
    // Logout
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserClient.studentLogout(deleteSessionId: Session.loggedSession.id, expireAt: Session.loggedSession.expiration, completion: handleLogoutResponse(deactivateSession:error:))
    }
    // Reload data
    @IBAction func reload(_ sender: Any) {
        LocationClient.reload(completion: handleStudentInfo(result:))
    }
    
    
    
    // MARK:- Helpers and Functions
    
    // Populate array of data for each student (StudentTableData.student *Singletone*)
    func handleStudentInfo(result:Result<Locations?, Error>) { 
        switch result {
        case .success(let studentInfo):
            
            if let studentInfo = studentInfo {
                for i in studentInfo.results {
                    let name = i.firstName
                    let secondName = i.lastName
                    let fullName = String("\(name) \(secondName)")
                    let student = StudentTableData(studentName: fullName, studentURL: i.mediaURL)
                    StudentTableData.student.append(student)
                }
                self.ListTableView.reloadData()
            }
            
        case .failed( _):
            // print(error)
            alertMessage(title: "Failed to setup the Map data", message: "Check your network Connection")
        }
    }
    
    // Handle logout
    func handleLogoutResponse(deactivateSession: Bool?, error: Error?) {
        if deactivateSession == true {
            Session.loggedSession.id = ""
            Session.loggedSession.expiration = ""
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            alertMessage(title: "Failed to logout", message: "Cheack your internet connection and Try again.")
        }
    }
    
    // Error message alert tool
    func alertMessage(title:String,message:String?) {
        let alertVC = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    
    // MARK:- table view data source and delegate functions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentTableData.student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = StudentTableData.student[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else { return ListTableViewCell() }
        cell.setCellInfo(studentName: student.studentName  , mediaUrl: student.studentURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = StudentTableData.student[indexPath.row]
        
        guard let url = URL(string: selected.studentURL), UIApplication.shared.canOpenURL(url)
            else {
                alertMessage(title: "Can't open student URL", message: "Unable to get student URL. Check if the URL is complete.") ; return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    
    
}
