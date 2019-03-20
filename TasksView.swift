//
//  TasksView.swift
//  Title Timer
//
//  Created by John Garrett on 3/10/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class TasksView: NSScrollView, NSTableViewDelegate, NSTableViewDataSource {
	//ps -eo pid,state,start,etime,,command
	// /bin/ps
	@IBOutlet var tableView: NSTableView!
    struct Task{
        var name: String = "Unknown Application"
        var time: String = "0 seconds"
        init(name n: String, time t: String){
            time = convertTime(t)
            name = n
        }
        private var needsConversion = false //does the time need to be converted?
        private var hours: String?
        private var mins: String?
        
        //convert from 00:00.00 format to 0 hrs 00 mins
        private func convertTime(_ time: String) -> String{
            let text = time.split(separator: ":")
            var hours = String(text[0])
            var mins = String(text[1].split(separator: ".")[0])
        
            hours = Int(hours) ?? 0 > 0                                                   //cast it to int and see if the result is > 0 (not castable == 0)
                        ? Int(hours)! > 9                                                 //if it's greater than 0, see if its a single digit or not
                        ? "\(hours) hrs"                                                  //double digits (e.g. 12 hrs)
                        : "\(String(hours.prefix(1))) \(Int(hours)! == 1 ? "hr" : "hrs")" //truncate it to 1 digit. if its == 1, append hr not hrs
                    : ""                                                                  //if it's less than 0, count == 0
            mins  = Int(mins) ?? 0 > 0  ? Int(mins)!  > 9 ? "\(mins) mins" : "\(String(mins.prefix(1))) mins" : "" //similar logic to above
            
            return hours.count + mins.count > 0 ? "\(hours) \(mins)" : "< 1 minute"
        }
    }
    
    var tasks = [Task]()
    
	func loadTasks(){
		let task = Process()
		task.launchPath = "/bin/ps" //the location of the ps command
        task.arguments = ["-eo time, command",
                          "-u \(NSUserName())"] //only display processes run by the user
		let pipe = Pipe()
		task.standardOutput = pipe
		task.standardError  = pipe
		task.launch()
		task.waitUntilExit()
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        /*-----------------
         Sample Ouput
         
         TIME COMMAND
         7:51.71 /sbin/launchd
         0:09.53 /usr/sbin/syslogd
         
        -------------*/
        
        for line in output.split(separator: "\n"){
            var splitLine = line.split(separator: " ", maxSplits: 1)
            let time = splitLine[0]
            let command = splitLine.count > 1 ? splitLine[1] : "Unknown Application"
            let path = command.split(separator: "/")//split by directories

            if path[0] == "Applications"{ //if the program is known to the user basically
                let programName = path[path.count - 1] //the last item in the path e.g. /var/apps/name -> name
                                 .split(separator: "-") //dont read the flags
                
                tasks.append(Task(name: String(programName[0]), time: String(time)))
                
            }
        }
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tasks.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text = ""
        var id   = ""
        
        switch tableColumn{
        case tableView.tableColumns[0]:
            text = tasks[row].name
            id = "taskCell"
        case tableView.tableColumns[1]:
            text = tasks[row].time
            id = "timeCell"
        default:
            print("Error assigning value")
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: id), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}
