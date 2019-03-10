//
//  TasksView.swift
//  Title Timer
//
//  Created by John Garrett on 3/10/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class TasksView: NSScrollView, NSTableViewDelegate, NSTableViewDataSource {
	//ps -eo pid,state,start,etime,,command
	// /bin/ps
	
	@IBOutlet var tableView: NSTableView!
}
