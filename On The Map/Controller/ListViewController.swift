//
//  ListViewController.swift
//  On The Map
//
//  Created by Dane Miller on 10/30/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        studentTableView.delegate = self
        studentTableView.dataSource = self
        updateData()

        // Do any additional setup after loading the view.
    }
    
    func updateData(){
        studentTableView.reloadData()
    }
    func refresh(){
        self.updateData()

    }

    

}

extension ListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return StudentInformation.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
        let student = StudentInformation.studentLocations[indexPath.row]
        cell.StudentName.text = "\(student.firstName!) \(student.lastName!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = StudentInformation.studentLocations[(indexPath as NSIndexPath).row]
        if validLink(student.mediaURL){
            UIApplication.shared.open(NSURL(string: student.mediaURL)! as URL)
        } else {
            alert(title: "Invalid Link", message: "The media link attched is not a valid link and thus cannot be opened.", controller: self)
        }
    }
    
    
    
    
    
}
