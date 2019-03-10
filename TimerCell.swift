//
//  TimerCell.swift
//  Title Timer
//
//  Created by John Garrett on 3/9/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class TimerCell: NSTableRowView {
	@IBOutlet var titleTextField: NSTextField!
	@IBOutlet var timerTextField: NSTextField!
	@IBOutlet var resetButton: NSButton!
	@IBOutlet var actionButton: NSButton!

	public var isRunning = false
	private var counter = 0.0{
		didSet{
			DispatchQueue.main.async { [unowned self] in
				self.timerTextField.stringValue = String(format: "%.1f", self.counter)
			}
			print(counter)
		}
	}
	private var timer = Timer()
    
	@IBAction func actionButtonClick(_ sender: NSButton) {
		let pause = "\u{23F8}\u{FE0E}"
		
		//sender.title = isRunning ? "P" : "▶" //force unicode expression TODO
		isRunning ? pauseTimer() : startTimer()
	}
	@IBAction func resetButtonClick(_ sender: NSButton) {
		resetTimer()
	}
	
	private func startTimer() {
		//guard !isRunning else { return }
		if isRunning{
			return
		}
		DispatchQueue.global(qos: .background).async {
			self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.UpdateTimer), userInfo: nil, repeats: true)
		}
		actionButton.title = "P"
		isRunning = true
	}
	
	private func pauseTimer() {
		actionButton.title = "▶"
		timer.invalidate()
		isRunning = false
	}
	
	private func resetTimer() {
		actionButton.title = "▶"
		timer.invalidate()
		isRunning = false
		counter = 0.0
		timerTextField.stringValue = String(counter)
	}
	@objc func UpdateTimer() {
		counter = counter + 0.1
	}
}
