//
//  Album.swift
//  TableViewAppM1
//
//  Created by user156499 on 6/22/20.
//  Copyright © 2020 MZN0047. All rights reserved.
//
import UIKit
import Foundation

class Meeting : NSObject, NSCoding {
    var title:String
    var location:String
    var date:Date
    var people:Array<String>?
    var eventId:String
    
    init?(title:String,location:String,date:Date,people:Array<String>?,eventId:String) {
        if title.isEmpty { return nil }
        self.title = title
        self.location=location
        self.date=date
        self.people=people
        self.eventId=eventId
    }
    
    struct PropertyKey {
        static let title = "Title"
        static let location = "location"
        static let date = "Date"
        static let people = "People"
        static let eventId = "Event"
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(people, forKey: PropertyKey.people)
        aCoder.encode(eventId, forKey: PropertyKey.eventId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date
        let people = aDecoder.decodeObject(forKey: PropertyKey.people) as? Array<String>
        var eventId = aDecoder.decodeObject(forKey: PropertyKey.eventId) as? String
        if eventId == nil {eventId = ""}
        self.init(title:title!, location:location!, date:date!, people:people!,eventId:eventId!)
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meetings")
    
    func stringDate() -> String{
        let df = DateFormatter()
        df.dateFormat = "MM-dd hh:mm"
        return df.string(from: date)
    }
}
