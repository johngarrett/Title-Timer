//
//  StatusMenuController.swift
//  Title Timer
//
//  Created by John Garrett on 3/9/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
	@IBOutlet weak var menu: NSMenu!
	@IBOutlet weak var timerView: TimerView!
	var timerMenuItem: NSMenuItem!
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	override func awakeFromNib() {
		statusItem.title = "Title Timer"
		statusItem.menu = menu
		timerMenuItem = menu.item(withTitle: "Timers")
		timerMenuItem.view = timerView
		let rows = CGFloat(timerView.numberOfRows(in: timerView.tableView))
		let rowHeight = timerView.tableView.rowHeight + 2.75
		let height = rows * rowHeight < 4 * rowHeight ? rows * rowHeight : 4 * rowHeight //4 * row height is the max
		timerView.frame = NSRect(x: timerView.frame.minX, y: timerView.frame.minY, width: timerView.frame.width, height: height)
	}
	@IBAction func quitClicked(_ sender: NSMenuItem) {
		NSApplication.shared.terminate(self)
	}
	@IBAction func prefrencesClicked(_ sender: NSMenuItem) {
		print("hey they wanna see prefrences?")
	}
	
	@IBAction func addClicked(_ sender: Any) {
		print("they wanna add somethig")
	}
	
}
