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
	@IBOutlet var actionButton: NSButton!
	
	public var isRunning = false
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
	@IBAction func actionButtonClick(_ sender: NSButton) {
		isRunning = !isRunning
		let pause = "\u{23F8}\u{FE0E}"
		
		sender.title = isRunning ? pause : "▶" //force unicode expression TODO
	}
}
