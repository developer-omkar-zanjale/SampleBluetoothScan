//
//  BTListDeviceCard.swift
//  BluetoothScanSample
//
//  Created by Omkar Zanjale on 25/11/24.
//

import SwiftUI

struct BTListDeviceCard: View {
    
    @ObservedObject var device: BTDevice
    var onClick: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                Image(AssetsConstant.bluetoothLogo)
                    .resizable()
                    .frame(width: width * 0.08, height: width * 0.08)
                    .padding(.trailing, 4)
                Text(device.peripheral.name ?? "-")
                    .font(.title2)
                    .foregroundStyle(Color.white)
                Spacer()
                if device.status == .connecting || device.status == .disconnecting {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.regular)
                        .tint(Color.white)
                }
                if device.status == .connected {
                    Image(systemName: AssetsConstant.sys_checkmark_circle_fill)
                        .resizable()
                        .frame(width: width * 0.07, height: width * 0.07)
                        .foregroundStyle(Color.green)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(Color.gray)
                .onTapGesture {
                    onClick()
                }
        }
        .padding(.horizontal)
    }
}
