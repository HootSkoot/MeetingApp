//
//  RootTableViewController.swift
//  TableViewAppM1
//
//  Created by user156499 on 6/4/20.
//  Copyright © 2020 MZN0047. All rights reserved.
//

import UIKit
import os.log
import EventKit


class RootTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    fileprivate static let rootKey = "rootKey"
    private static let cellTableIdentifier = "MeetingName"
    private var meetings: Array<Meeting> = []
    //var newAlbum: Dictionary<String, AnyObject>!
    private var editingIndexPath: IndexPath!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        if let savedMeetings = loadMeetings() {
            meetings += savedMeetings
        } else {
            loadSampleMeetings()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    private func loadSampleMeetings(){
        let meeting1 = Meeting(title : "sample", location : "Red Room", date : Date(),
                              people: ["samplePerson", "samplePerson"], eventId: "blank")
        
        meetings += [meeting1] as! Array<Meeting>
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: RootTableViewController.cellTableIdentifier, for: indexPath)
        let rowData = meetings[indexPath.row]
        cell.textLabel?.text = rowData.title
        let df = DateFormatter()
        df.dateFormat = "MM-dd hh:mm"
        cell.detailTextLabel?.text = df.string(from: rowData.date)
        return cell

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //checking segue types
        if segue.identifier == "AddMeeting" {
            //send existing album data to add new album
            //let listVC = segue.destination as! UINavigationController
            //let childVC = listVC.topViewController as! NewAlbumViewController
            
            
        } else if segue.identifier == "ShowMeeting" {
            //checking whether segue is an edit or showing detail
            //let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let listVC = segue.destination as? MeetingDetailViewController
            let selectedCell = sender as? UITableViewCell
            let indexPath = tableView.indexPath(for: selectedCell!)
            listVC?.selectedMeeting = meetings[(indexPath?.row)!]
            //listVC.navigationItem.title = meetings[indexPath.row].title
        } else if segue.identifier == "editMeeting" {
            //let new view know its in edit mode, and send existing album
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            //let indexPath = tableView.indexPathForSelectedRow
            let listVC = segue.destination as! NewMeetingViewController
            listVC.editingMeeting = true
            editingIndexPath = indexPath
            listVC.newMeeting = meetings[indexPath.row]
        }
            /*} else {
            // Favorites list
            listVC.fontNames = favoritesList.favorites
            listVC.navigationItem.title = "Favorites"
            listVC.showsFavorites = true
        }*/
    }
    
    @IBAction func unwindFromAdd(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewMeetingViewController
        //let sourceViewController = sender.source as! NewAlbumViewController
        //newAlbum = sourceViewController.newAlbum
        {
            if sourceViewController.editingMeeting == true {
                meetings[editingIndexPath.row] = sourceViewController.newMeeting!
                tableView.reloadRows(at: [editingIndexPath], with: .none)
                sourceViewController.editingMeeting = false
            } else {
                let newMeeting = sourceViewController.newMeeting
                let newIndexPath = IndexPath(row: meetings.count, section: 0)
                meetings.append(newMeeting!)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMeetings()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            // Delete the row from the data source
            let id = meetings[indexPath.row].eventId
            meetings.remove(at: indexPath.row)
            saveMeetings()
            let store = EKEventStore()

            
            
            store.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = store.calendarItem(withIdentifier: id)
                    
                    if event != nil {
                        do {try store.remove(event as! EKEvent, span: .thisEvent )  } catch let error as NSError { print("failed with : \(error)") }
                    }
                    //completion?(true, nil)
                }
                
            })
            do { try store.commit() } catch let e as NSError { print("failed at : \(e)")}
            tableView.deleteRows(at: [indexPath],
                                 with: UITableViewRowAnimation.fade)
        }
        
    }
    
    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        url = URL(fileURLWithPath: "") as NSURL?      // create a blank path
        url = urls.first?.appendingPathComponent("data.archive") as NSURL?
        return url!
    }
    
    private func saveMeetings(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meetings, toFile: Meeting.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meeting Successfuly Saved", log: OSLog.default, type:.debug)
        } else {
            os_log("failed to save", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeetings() -> [Meeting]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meeting.ArchiveURL.path) as? [Meeting]
    }


}
