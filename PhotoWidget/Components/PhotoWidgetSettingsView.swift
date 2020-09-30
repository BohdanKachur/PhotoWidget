//
//  PhotoWidgetSettingsView.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 25.09.2020.
//

import SwiftUI
import WidgetKit

struct PhotoWidgetSettingsView: View {
    
    @Binding var refreshInterval: RefreshInterval
    
    var body: some View {
        Form {
            
            Section(header: Text("WIDGET SETTINGS")) {
                Picker("Photo Refresh Interval", selection: $refreshInterval) {
                    ForEach(RefreshInterval.allCases) { i in
                        Text(i.rawValue).tag(i)
                    }
                }
                
                Button("Sync widget settings") {
                    PhotoSelectionStore.shared.refreshInterval = refreshInterval
                    
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
            }
            
            Section(header: Text("APP INFO")) {
                
                NavigationLink(
                    destination: Text("How to use screen"),
                    label: {
                        Text("How to use")
                    })
                
                HStack {
                    Text("App Version")
                    Spacer()
                    Text("1.0.0")
                }
            }
            
        }.navigationBarTitle(Text("Settings"), displayMode: .inline)
    }
}

struct PhotoWidgetSettingsView_Previews: PreviewProvider {
    var refreshInterval: RefreshInterval = .never
    static var previews: some View {
        PhotoWidgetSettingsView(refreshInterval: .constant(.never))
    }
}
