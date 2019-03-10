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
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 4
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("TimerCell"), owner: nil) as? TimerCell {
			cell.titleTextField.stringValue = "Testing a title"
			cell.timerTextField.stringValue = "NUMOIEJRS"
			return cell
		}
		print("no sir")
		return nil
	}

}
