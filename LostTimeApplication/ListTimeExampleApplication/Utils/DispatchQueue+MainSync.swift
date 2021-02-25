//
//  DispatchQueue+MainSync.swift
//  ListTimeExampleApplication
//
//  Created by Andrew Romanov on 23.02.2021.
//

import Foundation

extension DispatchQueue {
    static func execSyncOnMain(_ block: () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }
}
