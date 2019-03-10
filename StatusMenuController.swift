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
	}
	@IBAction func quitClicked(_ sender: NSMenuItem) {
		NSApplication.shared.terminate(self)
	}
	@IBAction func prefrencesClicked(_ sender: NSMenuItem) {
	}
	
}
