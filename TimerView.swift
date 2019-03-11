//
//  TimerView.swift
//  Title Timer
//
//  Created by John Garrett on 3/9/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

protocol TimerDelegate {
	func removeCell(withString string: String)
}

class TimerView: NSScrollView, NSTableViewDelegate, NSTableViewDataSource, TimerDelegate{
	
	@IBOutlet var tableView: NSTableView!
	public var timers = [String]()
	public var delegate: MenuDelegate?
	func numberOfRows(in tableView: NSTableView) -> Int {
		return timers.count
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("TimerCell"), owner: nil) as? TimerCell {
			cell.titleTextField.stringValue = timers[row]
			cell.elapsedTime = UserDefaults.standard.double(forKey: "\(timers[row])_TIME_ELAPSED")
			cell.time        = UserDefaults.standard.string(forKey: "\(timers[row])_TIME") ?? "0 seconds"
			cell.delegate = self
			return cell
		}
		return nil
	}
	
	func removeCell(withString string: String){
		guard let index = timers.firstIndex(of: string) else { return }
		let deletionIndex = IndexSet(integer: index)
		tableView.removeRows(at: deletionIndex, withAnimation: .slideLeft)
		timers.remove(at: index)
		let defaults = UserDefaults.standard
		defaults.set(timers, forKey: "userTimers")
		delegate?.calculateHeight()
	}
	//pause the timers causing the times to be saved
	func saveValues(completion: ()-> Void){
		for i in 0...timers.count - 1 {
			if let cell = tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? TimerCell{
				cell.pauseTimer()
			}
		}
		completion()
	}
}
