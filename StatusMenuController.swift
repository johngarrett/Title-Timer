//
//  StatusMenuController.swift
//  Title Timer
//
//  Created by John Garrett on 3/9/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

protocol MenuDelegate{
	func calculateHeight()
}

class StatusMenuController: NSObject, MenuDelegate {
	@IBOutlet weak var menu: NSMenu!
	@IBOutlet weak var timerView: TimerView!
	var timerMenuItem: NSMenuItem!
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	override func awakeFromNib() {
		loadTimers()
		statusItem.title = "⑉"
		statusItem.menu = menu
		timerView.delegate = self
		timerMenuItem = menu.item(withTitle: "Timers")
		timerMenuItem.view = timerView
		calculateHeight()
	}
	
	private func loadTimers(){
		let defaults = UserDefaults.standard
		timerView.timers = defaults.stringArray(forKey: "userTimers") ?? [String]()
	}
	
	func calculateHeight(){
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
		let alert = NSAlert()
		alert.messageText = "Enter the name of the new timer:"
		alert.addButton(withTitle: "Ok")
		alert.addButton(withTitle: "Cancel")
		
		let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: alert.window.frame.width - 100, height: 24))
		alert.accessoryView = textField
		
		let buttonPressed = alert.runModal()
		
		if buttonPressed == NSApplication.ModalResponse.alertFirstButtonReturn{
			let defaults = UserDefaults.standard
			var array = defaults.stringArray(forKey: "userTimers") ?? [String]()
			array.append(textField.stringValue)
			defaults.set(array, forKey: "userTimers")
			timerView.timers = array
			let insertionIndex = IndexSet(integer: timerView.timers.count - 1)
			timerView.tableView.insertRows(at: insertionIndex, withAnimation: .effectGap)
			calculateHeight()
		}
	}
	
}
