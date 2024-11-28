//
//  Enums.swift
//  BluetoothScanSample
//
//  Created by Omkar Zanjale on 25/11/24.
//

import Foundation

enum BTSystemState {
    case settingUp
    case powerOn
    case powerOff
    case unAuth
    case unsupported
}

enum BTDeviceStatus {
    case ready
    case connecting
    case disconnecting
    case connected
    case disconnected
}
