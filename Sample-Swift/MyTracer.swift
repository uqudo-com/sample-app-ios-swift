//
//  MyTracer.swift
//  Sample-Swift
//
//  Created by NooN on 28/6/24.
//

import Foundation
import UqudoSDK

@objc class MyTracer: UQTracer {
    override init() {
        super.init()
        print("Initiating UQTrace...")
    }
    @objc override func trace(_ trace: UQTrace) {
        print("Trace info: \(trace.traceInfo())")
    }
}
