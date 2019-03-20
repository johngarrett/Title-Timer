//
//  TasksView.swift
//  Title Timer
//
//  Created by John Garrett on 3/10/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class TasksView: NSScrollView, NSTableViewDelegate, NSTableViewDataSource {
	@IBOutlet var tableView: NSTableView!
    
    var tasks = [Task]() { didSet { tasks = tasks.sorted{ $0 > $1 } } } //sort upon setting
    
	func loadTasks(){
        //TODO: Move to prefrences
        UserDefaults.standard.set(["Core Sync", "Discord Helper", "Google Chrome Helper", "SafariQuickLookPreview"], forKey: "whitelist")
        UserDefaults.standard.set(["Helper", "Sync", "Service", "Reporter", "Crash", "."], forKey: "disallowed_types")
        
		let task = Process()
		task.launchPath = "/bin/ps"              //the location of the ps command
        task.arguments = ["-eo time, command",   //show uptime and command location
                          "-u \(NSUserName())"]  //only display processes run by the user
		let pipe = Pipe()
		task.standardOutput = pipe
		task.standardError  = pipe
		task.launch()
		task.waitUntilExit()
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
        //convert each line into a task
        for line in output.split(separator: "\n"){
            if let task = Task.init(fromPSLine: line),
                                    task.compoundTime > 0{ // dont show tasks open for < 1 minute
                tasks.append(task)
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
