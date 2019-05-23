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
    var iconData: Data?                       //the application's icon
    var compoundTime = 0                      //total time in minutes
    var time: String = "0 seconds"            //time string to be displayed
    var name: String = "Unknown Application"  //application name (not directory)
    
    private var hours: Int?                 //integer value of hours
    private var mins:  Int?                 //integer value of minutes
    private var path: String.SubSequence?   //the path to the application
    
    init(name n: String, time t: String, path p: String.SubSequence?){
        time = convertTime(t)
        name = n
        path = p
        loadIcon()
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
        let path = command.split(separator: "/")   //split by directories
        if path[0] == "Applications"{              //if the program is known to the user basically
            let programName = path[path.count - 1] //the last item in the path e.g. /var/apps/name -> name
                .split(separator: "-")             //dont read the flags
            
            if let list = UserDefaults.standard.stringArray(forKey: "disallowed_types"){       //refrence against the disallowed types
                for type in list{                                                              //types we don't want shown, user configurable (e.g. "Helper")
                    if programName[0].lowercased().contains(type.lowercased()) { return nil }  //fail when the name contains the bannned type. (e.g. "Google Chrome Helper")
                }
            }
            
            if let list = UserDefaults.standard.stringArray(forKey: "whitelist"){    //try to pull the whitelist from defaults
                if list.firstIndex(of: String(programName[0])) != nil { return nil } //if the program exists in the whitespace
            }
            
            self.init(name: String(programName[0]), time: String(taskTime), path: command) //if there is no whitelist set
        }
        else {
            return nil                             //if it is not something we should show the user, initilization failed
        }
    }
    
    //convert from 00:00.00 format to 0 hrs 00 mins
    private mutating func convertTime(_ time: String) -> String{
        let text = time.split(separator: ":")
        var hrs = String(text[0])
        var mns = String(text[1].split(separator: ".")[0])
        
        hours = Int(hrs)
        mins  = Int(mns)
        compoundTime = (hours ?? 0) * 60 + (mins ?? 0)
        hrs = hours ?? 0 > 0                                    //see if int is > 0 (not castable == 0)
            ? "\(hours!) \(hours! == 1 ? "hr" : "hrs")"         //convert to int to truncate leading 0s if its == 1, append hr not hrs
            : ""                                                //if it's less than 0, count == 0
        mns  = mins ?? 0 > 0  ? "\(mins!) \(mins! == 1 ? "min" : "mins")" : "" //similar logic to above
        
        return hrs.count + mns.count > 0 ? "\(hrs) \(mns)" : "< 1 minute"
    }
    
    /*
     Extract the application's icon.
     
        - Each application's info.plist file (located in /Name.app/Contents) declares its icon file name
        - The key value the icon is stored in is: "CFBundleIconFile"
        - Icons are kept in the Resources folder (/Name.app/Contents/Resources) and are of the file type .icns

    */
    private mutating func loadIcon(){
        guard let pth = path, iconData == nil else { return }  //only load this image once
    
        /*
         We are looking for the path to the Contents folder
            - it's usually 2 but some users have nested folders
         (e.g. /Applications/Slack.app/Contents)
        */
        print(pth)
        var resourceLocaiton = "/"
        let folders = pth.split(separator: "/")
        let index = folders.firstIndex(of: "Contents") ?? 0
        for dir in folders[0...index]{
            resourceLocaiton.append("\(dir)/")             //after completion, resource location is .../Contents/
        }
        
        let plistFile = "\(resourceLocaiton)Info.plist"                                              //extract each app's info.plist
        if var iconName = NSDictionary(contentsOfFile: plistFile)?["CFBundleIconFile"] as? String{  //CFBundleIconFile is application's icon name
            if !iconName.contains(".icns") { iconName.append(".icns") }                              //add extension if it's missing
            let iconPath = "\(resourceLocaiton)Resources/\(iconName)"                                //.../Contents/Resources/name.icns
           
            if let data = FileManager.default.contents(atPath: iconPath){ iconData = data }         //read and set the data
        }
    }
}

/*
 allow comparability (> , < , ==)
 
 lhs -> left hand side
 rhs -> right hand side
*/

extension Task: Comparable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.compoundTime == rhs.compoundTime
    }
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.compoundTime < rhs.compoundTime
    }
    static func > (lhs: Task, rhs: Task) -> Bool {
        return lhs.compoundTime > rhs.compoundTime
    }
}
