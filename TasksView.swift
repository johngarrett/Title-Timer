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
		task.arguments = ["start", "etime", "command"]
		print(task.launchPath)
		
		let pipe = Pipe()
		task.standardOutput = pipe
		
		let file = pipe.fileHandleForWriting
		task.launch()
		
		let data = file.readDataToEndOfFile()
		
		let string = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)
		print(string)
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
