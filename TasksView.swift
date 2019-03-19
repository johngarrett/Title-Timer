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
	var tasks = [Substring]()
    var uptime = [Substring]()
    
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
                
                uptime.append(time)
                print(programName[0])
                tasks.append(programName[0])
            }
        }
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tasks.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text = ""
        var id = ""
        
        switch tableColumn{
        case tableView.tableColumns[0]:
            text = String(tasks[row])
            id = "taskCell"
        case tableView.tableColumns[1]:
            text = String(uptime[row])
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
