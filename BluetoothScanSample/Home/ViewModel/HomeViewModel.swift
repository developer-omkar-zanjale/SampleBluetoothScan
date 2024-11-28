//
//  HomeViewModel.swift
//  BluetoothScanSample
//
//  Created by Omkar Zanjale on 25/11/24.
//

import Foundation
import CoreBluetooth

class HomeViewModel: NSObject, ObservableObject {
    
    @Published var btSystemState: BTSystemState = .settingUp
    @Published var isScanning: Bool = false
    
    @Published var devices: [BTDevice] = []
    
    private var centralManager: CBCentralManager?
    let addDeviceQueue = DispatchQueue(label: "com.addDevice.queue", qos: .userInteractive, attributes: .concurrent)
    
    override init() {
        super.init()
        self.requestPermission()
    }
    
    func requestPermission() {
        self.btSystemState = .settingUp
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startSearching() {
        self.isScanning = true
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    func stopSearching() {
        self.isScanning = false
        centralManager?.stopScan()
    }
}
//
//MARK:
//
extension HomeViewModel: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.centralManager = central
        switch central.state {
        case .unknown:
            self.btSystemState = .unAuth
        case .resetting:
            self.btSystemState = .unAuth
        case .unsupported:
            self.btSystemState = .unsupported
        case .unauthorized:
            self.btSystemState = .unAuth
        case .poweredOff:
            self.btSystemState = .powerOff
        case .poweredOn:
            self.btSystemState = .powerOn
            self.startSearching()
        @unknown default:
            self.btSystemState = .unAuth
        }
        LoggerService.printLog("centralManagerDidUpdateState: \(btSystemState)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else {return}
        addDeviceQueue.async {
            self.addDevice(peripheral: peripheral)
        }
    }
    
    
    private func addDevice(peripheral: CBPeripheral) {
        asyncQueue {
            if !self.devices.contains(where: {$0.peripheral.name == peripheral.name}) {
                LoggerService.printLog("didDiscover Adding new Device: \(peripheral.name!)")
                let obj = BTDevice(name: peripheral.name!, peripheral: peripheral)
                
                self.devices.append(obj)
            }
        }
    }
    
    func connectDevice(peripheral: CBPeripheral) {
        if let connectedDeviceIndex = self.devices.firstIndex(where: {$0.peripheral.name == peripheral.name}), connectedDeviceIndex < self.devices.count {
            if (self.devices[connectedDeviceIndex].status == .connected || self.devices[connectedDeviceIndex].status == .connecting) {
                LoggerService.printLog("Disconnecting device: \(peripheral.name!)")
                self.devices[connectedDeviceIndex].status = .disconnecting
                self.centralManager?.cancelPeripheralConnection(self.devices[connectedDeviceIndex].peripheral)
            } else {
                self.stopSearching()
                self.devices[connectedDeviceIndex].status = .connecting
                LoggerService.printLog("Connecting device: \(peripheral.name!)")
                centralManager?.connect(self.devices[connectedDeviceIndex].peripheral, options: nil)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard peripheral.name != nil else {return}
        if let connectedDeviceIndex = self.devices.firstIndex(where: {$0.peripheral.identifier == peripheral.identifier}), connectedDeviceIndex < self.devices.count {
            self.devices[connectedDeviceIndex].status = .connected
            LoggerService.printLog("didConnect device: \(peripheral.name!)")
            self.devices[connectedDeviceIndex].peripheral.discoverServices(nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        guard peripheral.name != nil else {return}
        if let connectedDeviceIndex = self.devices.firstIndex(where: {$0.peripheral.identifier == peripheral.identifier}), connectedDeviceIndex < self.devices.count {
            self.devices[connectedDeviceIndex].status = .disconnected
            LoggerService.printLog("didDisconnectPeripheral device: \(peripheral.name!)")
        }
    }
}
