//
//  JBTimer
//
//  Copyright (c) 2016 Juan Pablo  Boero Alvarez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



import Foundation

/**
 Repeating timer based on Grand Central Dispatch. [GitHub link](https://github.com/JuanPabloBoero/JBTimer/)
 
 - Parameter timeInMilliSecs: An integer that defines the desired repeating time in milliseconds.
 - Parameter closure: closure that will execute the tasks defined inside.
 - Returns: `Void`
 - Version: 4.0
 - Author: Juan Pablo Boero Alvarez
 */
class JBTimer {
    
    fileprivate var timerObject: DispatchSourceTimer?
    
    /**
     Starts the repeating timer each time that `timeInMilliSecs` lapses.
     
     - Parameter timeInMilliSecs: An integer that defines the desired repeating time in milliseconds.
     - Parameter closure: closure that will execute the tasks defined inside.
     
     */
    func repeateTimer(timeInMilliSecs: Int, closure: @escaping ()->Void) {
        let queue = DispatchQueue(label: "com.domain.app.timer", attributes: .concurrent)
        timerObject?.cancel()        // cancel previous timer if any
        timerObject = DispatchSource.makeTimerSource(queue: queue)
        timerObject?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(timeInMilliSecs), leeway: DispatchTimeInterval.seconds(1))
        timerObject?.setEventHandler(handler: closure)
        timerObject?.resume()
    }
    
    /**
     Stops the repeating timer.
     */
    func stopTimer() {
        timerObject?.cancel()
        timerObject = nil
    }
}
