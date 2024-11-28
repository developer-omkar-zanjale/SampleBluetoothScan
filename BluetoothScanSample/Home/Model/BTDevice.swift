//
//  BTDevice.swift
//  BluetoothScanSample
//
//  Created by Omkar Zanjale on 25/11/24.
//

import Foundation
import CoreBluetooth

class BTDevice: NSObject, ObservableObject, Identifiable {
    
    let id = UUID()
    var name: String
    var peripheral: CBPeripheral
    @Published var status: BTDeviceStatus = .ready
    
    init(name: String, peripheral: CBPeripheral) {
        self.name = name
        self.peripheral = peripheral
        self.status = .ready
        super.init()
        peripheral.delegate = self
    }
}


extension BTDevice: CBPeripheralDelegate {
    
}
