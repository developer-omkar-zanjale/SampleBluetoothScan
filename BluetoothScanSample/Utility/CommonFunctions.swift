//
//  CommonFunctions.swift
//  BluetoothScanSample
//
//  Created by Omkar Zanjale on 25/11/24.
//

import Foundation

public func asyncQueue(completion: @escaping(()->())) {
    DispatchQueue.main.async {
        completion()
    }
}

public func asyncAfter(_ sec: Double = 1, completion: @escaping(()->())) {
    DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
        completion()
    }
}

