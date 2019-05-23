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
	@IBOutlet var actionButton:   NSButton!
    @IBOutlet var deleteButton:   NSButton!
    @IBOutlet var resetButton:    NSButton!
    
	private var timerBeganCounting = false
	private var startTime: CFAbsoluteTime?
	private var endTime:   CFAbsoluteTime?
	public var delegate:   TimerDelegate?
	public var isRunning = false

    public var elapsedTime: Double = 0.0 { //time thats calcuated
        didSet{
            UserDefaults.standard.set(elapsedTime, forKey:  "\(titleTextField.stringValue)_TIME_ELAPSED")
            self.updateText()
        }
    }
    public var time: String = "0 seconds"{ //time that's displayed
        didSet{
            UserDefaults.standard.set(time, forKey: "\(titleTextField.stringValue)_TIME")
            timerTextField.stringValue = time
        }
    }
    
	@IBAction func resetButtonClick(_ sender: NSButton) { resetTimer() }
	@IBAction func deleteButtonClick(_ sender: NSButton) {
		guard delegate != nil else { return }
		delegate?.removeCell(withString: titleTextField.stringValue)
	}

	//handles both pause and play
	@IBAction func actionButtonClick(_ sender: NSButton) {
		isRunning ? pauseTimer() : startTimer()
	}
	
	private func startTimer() {
        guard !isRunning else { return }
        actionButton.image = NSImage(named: "Pause")
        actionButton.image?.size = NSSize(width: 20, height: 20)
        
        isRunning = true
        if !timerBeganCounting{
            startTime = CFAbsoluteTimeGetCurrent() //track the starting time
            timerBeganCounting = true
        }
        timerTextField.stringValue = "Counting..."
        deleteButton.isEnabled = false
        resetButton.isEnabled = false
	}
	
    public func pauseTimer() { //pause is the only open method
        actionButton.image = NSImage(named: "Play")
        actionButton.image?.size = NSSize(width: 16.5, height: 16.5)
        deleteButton.isEnabled = true
        resetButton.isEnabled  = true
        isRunning = false
        endTime = CFAbsoluteTimeGetCurrent()
        guard startTime != nil, endTime != nil else { return }
        elapsedTime += endTime! - startTime!
        timerBeganCounting = false
        UserDefaults.standard.set(timerTextField.stringValue, forKey: "\(titleTextField.stringValue)_TIME")
    }
	
    private func resetTimer() {
        startTime = nil
        endTime   = nil
        actionButton.image = NSImage(named: "Play")
        actionButton.image?.size = NSSize(width: 18, height: 18)
        isRunning = false
        elapsedTime = 0.0
        timerTextField.stringValue = "0 seconds"
    }
    
    private func updateText(){
		let hours   = (Int(elapsedTime) / 3600) % 24
		let minutes = (Int(elapsedTime) / 60) % 60
		let seconds =  Int(elapsedTime) % 60
		
		let hoursString   = hours > 0 ? String("\(hours):") : "" //HOURS: or nothing
		let minutesString = minutes > 0 || hours > 0 ? String(format: "%02d", minutes) + String(":") : "" //HOURS:MINS:SEC or MINS:SEC or SEC
		let secondsString = minutes == 0 && hours == 0 ? "\(seconds) " + ((seconds == 1) ? "second" : "seconds") : String(format: "%02d ", seconds) //...:SEC or SEC seconds
		timerTextField.stringValue = hoursString + minutesString + secondsString
	}
}
