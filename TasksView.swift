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
		task.launchPath = "/bin/ps"
        let username = NSUserName()
        task.arguments = ["-eo time, command", "-u \(username)"]
		let pipe = Pipe()
		task.standardOutput = pipe
		task.standardError = pipe
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
            let path = command.split(separator: "/")

            if path[0] == "Applications"{ //if the program is known to the user basically
                let programName = path[path.count - 1] //the last item in the path e.g. /var/apps/name -> name
                                 .split(separator: "-") //dont read the flags
                
                uptime.append(time)
                tasks.append(programName[0])
            }
        }
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tasks.count
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("TimerCell"), owner: nil) as? TimerCell {
			return cell
		}
		return nil
	}
}
