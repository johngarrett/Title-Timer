//
//  TimerView.swift
//  Title Timer
//
//  Created by John Garrett on 3/9/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class TimerView: NSScrollView, NSTableViewDelegate, NSTableViewDataSource {

	@IBOutlet var tableView: NSTableView!
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 4
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("TimerCell"), owner: nil) as? TimerCell {
			cell.titleTextField.stringValue = "Trafficlight"
			cell.timerTextField.stringValue = "00:00:00"
			return cell
		}
		return nil
	}

}
