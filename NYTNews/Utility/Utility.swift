//
//  Utility.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

typealias Block = () -> Void

/**
 It runs a block of code on the main thread
 - Parameters:
 - block: The block of code to run
 - Returns:
 */
func RunOnMainThread(block: @escaping Block ) {
    guard Thread.isMainThread else {
        DispatchQueue.main.async {
            block()
        }
        return
    }
    block()
}

/**
 It runs a block of code on the background thread
 - Parameters:
 - block: The block of code to run
 - Returns:
 */
func RunInBackground(block: @escaping Block) {
    guard Thread.isMainThread  else {
        block()
        return
    }
    DispatchQueue.global().async {
        block()
    }
}
