//
//  AlbumDetailViewController.swift
//  TableViewAppM1
//
//  Created by user156499 on 6/5/20.
//  Copyright © 2020 MZN0047. All rights reserved.
//

import UIKit

class MeetingDetailViewController: UIViewController, UITableViewDataSource {

    var selectedMeeting = Meeting(title: "", location: "", date: Date(), people: [], eventId: "")
    
    @IBOutlet weak var meetingTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    //navigationItem.rightBarButtonItem = editButtonItem

        meetingTitleLabel.text = selectedMeeting?.title
        locationLabel.text = selectedMeeting?.location
        dateLabel.text = selectedMeeting?.stringDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tempAl =  selectedMeeting?.people
        return tempAl!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        let rowData = selectedMeeting?.people
        cell.textLabel?.text = rowData?[indexPath.row]
        return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
