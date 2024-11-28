//
//  HomeView.swift
//  BluetoothScanSample
//
//  Created by Omkar Zanjale on 25/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var homeVM = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.7), Color.blue.opacity(0.9), Color.blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                SearchingDeviceLoaderView()
                    .opacity((homeVM.isScanning && homeVM.devices.isEmpty) ? 1 : 0)
                if !homeVM.devices.isEmpty {
                    VStack {
                        HStack {
                            Text(homeVM.isScanning ? ViewStringContants.searching : ViewStringContants.devices)
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .padding(.leading)
                            Spacer()
                        }
                        ScrollView {
                            LazyVStack {
                                ForEach(homeVM.devices, id: \.self) { device in
                                    BTListDeviceCard(device: device) {
                                        self.homeVM.connectDevice(peripheral: device.peripheral)
                                    }
                                }
                            }
                        }
                        .refreshable {
                            self.homeVM.startSearching()
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
