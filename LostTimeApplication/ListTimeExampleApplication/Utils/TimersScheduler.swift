//
//  TimersScheduler.swift
//  ListTimeExampleApplication
//
//  Created by Andrew Romanov on 23.02.2021.
//

import Foundation
import Dispatch

let USEC_PER_SECS = 1_000_000

public extension TimeInterval {
    var dispatchInterval: DispatchTimeInterval {
        let microseconds = Int64(self * TimeInterval(USEC_PER_SECS)) // perhaps use nanoseconds, though would more often be > Int.max
        let result = microseconds < Int.max ? DispatchTimeInterval.microseconds(Int(microseconds)) : DispatchTimeInterval.seconds(Int(self))
        return result
    }
}

class TimersScheduler: NSObject {

    private var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "TimersQueue",
                                  qos: .userInitiated,
                                  attributes: [.concurrent],
                                  autoreleaseFrequency: .inherit,
                                  target: DispatchQueue.global(qos: .background))
        return queue
    }()
    private var timers = [DispatchSourceTimer]()

    func scheduleBlock(_ block: @escaping ()-> Void, withTime time: TimeInterval) {
        let timer = DispatchSource.makeTimerSource(flags: [],
                                                         queue: self.queue) as DispatchSourceTimer

        timer.setEventHandler(handler: block)
        timer.schedule(deadline: .now() + time.dispatchInterval,
                       repeating: time.dispatchInterval,
                       leeway: .milliseconds(100))
        timer.activate()
        self.timers.append(timer)
    }
}

