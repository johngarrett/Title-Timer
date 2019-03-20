//
//  Task.swift
//  Title Timer
//
//  Created by John Garrett on 3/19/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Foundation

/*-----------------
 Sample Ouput from terminal
 
 TIME COMMAND
 7:51.71 /sbin/launchd
 0:09.53 /usr/sbin/syslogd
 
 -------------*/

struct Task{
    var name: String = "Unknown Application"
    var time: String = "0 seconds"
    
    private var hours: Int?
    private var mins: Int?
    
    init(name n: String, time t: String){
        time = convertTime(t)
        name = n
    }
    
    /*
        Init from a line in terminal
 
        this will fail if it is not a process running from the user's application folder
            that way, it wont show as much garbage
    */
    
    init?(fromPSLine line: String.SubSequence){
        var splitLine = line.split(separator: " ", maxSplits: 1)
        let taskTime  = splitLine[0]
        let command = splitLine.count > 1 ? splitLine[1] : "Unknown Application"
        let path = command.split(separator: "/")//split by directories
        
        if path[0] == "Applications"{ //if the program is known to the user basically
            let programName = path[path.count - 1] //the last item in the path e.g. /var/apps/name -> name
                .split(separator: "-") //dont read the flags
           
            self.init(name: String(programName[0]), time: String(taskTime))
        }
        else {
            return nil
        }
    }
    
    //convert from 00:00.00 format to 0 hrs 00 mins
    private mutating func convertTime(_ time: String) -> String{
        let text = time.split(separator: ":")
        var hrs = String(text[0])
        var mns = String(text[1].split(separator: ".")[0])
        
        hours = Int(hrs)
        mins  = Int(mns)
        hrs = hours ?? 0 > 0                                    //see if int is > 0 (not castable == 0)
            ? "\(hours!) \(hours! == 1 ? "hr" : "hrs")"         //convert to int to truncate leading 0s if its == 1, append hr not hrs
            : ""                                                //if it's less than 0, count == 0
        mns  = mins ?? 0 > 0  ? "\(mins!) \(mins! == 1 ? "min" : "mins")" : "" //similar logic to above
        
        return hrs.count + mns.count > 0 ? "\(hrs) \(mns)" : "< 1 minute"
    }
}

/*
 allow comparability (> , < , ==)
 
 lhs -> left hand side
 rhs -> right hand side
*/

extension Task: Comparable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        //convert to minutes and compare (e.g. 1 hr 20 mins -> 80 mins)
        let lhsTime = (lhs.hours ?? 0) * 60 + (lhs.mins ?? 0)
        let rhsTime = (rhs.hours ?? 0) * 60 + (rhs.mins ?? 0)
        
        return lhsTime == rhsTime
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        let lhsTime = (lhs.hours ?? 0) * 60 + (lhs.mins ?? 0)
        let rhsTime = (rhs.hours ?? 0) * 60 + (rhs.mins ?? 0)

        return lhsTime < rhsTime
    }
    static func > (lhs: Task, rhs: Task) -> Bool {
        let lhsTime = (lhs.hours ?? 0) * 60 + (lhs.mins ?? 0)
        let rhsTime = (rhs.hours ?? 0) * 60 + (rhs.mins ?? 0)
        
        return lhsTime > rhsTime
    }
}