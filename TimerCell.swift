//
//  TimerCell.swift
//  Title Timer
//
//  Created by John Garrett on 3/9/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa
import CoreFoundation

class TimerCell: NSTableRowView {
	@IBOutlet var titleTextField: NSTextField!
	@IBOutlet var timerTextField: NSTextField!
	@IBOutlet var resetButton: NSButton!
	@IBOutlet var actionButton: NSButton!

	private var startTime: CFAbsoluteTime?{
		didSet{
			print("START TIME: \(startTime!)")
		}
	}
	private var endTime:   CFAbsoluteTime?{
		didSet{
			print("END TIME: \(endTime!)")
		}
	}
	
	var elapsedTime:Double = 0.0{
		didSet{
			self.updateText()
		}
	}
	public var isRunning = false
	private var timerBeganCounting = false
	
	@IBAction func resetButtonClick(_ sender: NSButton) { resetTimer() }

	//handles both pause and play
	@IBAction func actionButtonClick(_ sender: NSButton) {
		//let pause = "\u{23F8}\u{FE0E}"
		isRunning ? pauseTimer() : startTimer()
	}
	
	
	private func startTimer() {
		
		guard !isRunning else { return }
		actionButton.title = "P"
		isRunning = true
		//track the starting time
		if !timerBeganCounting{
			startTime = CFAbsoluteTimeGetCurrent()
			timerBeganCounting = true
		}
		timerTextField.stringValue = "Counting..."
	}
	
	private func pauseTimer() {
		actionButton.title = "▶"
		isRunning = false
		endTime = CFAbsoluteTimeGetCurrent()
		guard startTime != nil, endTime != nil else { return }
		elapsedTime += endTime! - startTime!
		timerBeganCounting = false
	}
	
	private func resetTimer() {
		actionButton.title = "▶"
		isRunning = false
		timerTextField.stringValue = "0"
	}
	private func updateText(){
		let hours   = (Int(elapsedTime) / 3600) % 24
		let minutes = (Int(elapsedTime) / 60) % 60
		let seconds =  Int(elapsedTime) % 60
		
		let hoursString   = hours > 0 ? String("\(hours):") : "" //HOURS: or nothing
		let minutesString = minutes > 0 || hours > 0 ? String("\(minutes):") : "" //HOURS:MINS:SEC or MINS:SEC or SEC
		let secondsString = minutes == 0 && hours == 0 ? seconds == 1 ? String("\(seconds) second") : String("\(seconds) seconds") : String(seconds) //...:SEC or SEC seconds
		timerTextField.stringValue = hoursString + minutesString + secondsString
	}
}
