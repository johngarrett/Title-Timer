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
	
	func loadTasks(){
		let task = Process()
		task.launchPath = "/bin/ps"
        task.arguments = ["-eo time, command"]
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
            var splitLine = line.split(separator: " ")
            let time = splitLine[0]
            let command = splitLine.count > 1 ? splitLine[1] : "Unknown task"
            let path = command.split(separator: "/")
            let programName = path[path.count - 1]
            print(time)
            print(programName)
        }
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 0
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("TimerCell"), owner: nil) as? TimerCell {
			cell.timerTextField.stringValue = "0 seconds"
			return cell
		}
		return nil
	}
}
