//
//  TabViewController.swift
//  Title Timer
//
//  Created by John Garrett on 3/21/19.
//  Copyright © 2019 John Garrett. All rights reserved.
//

import Cocoa

class TabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
extension TabViewController {
    static func createFromSB() -> TabViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "TabViewController") as? TabViewController else {
            fatalError("Could not unwrap VC")
        }
        return vc
    }
}

