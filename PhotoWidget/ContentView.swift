//
//  ContentView.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 21.09.2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var photos: [PhotoModel] = PhotoSelectionStore.shared.loadPhotos()
    
    @State var selectedPhoto: Image? = nil
    @State var showCaptureImageView: Bool = false
    @State var showSettingsView: Bool = false
    @State var isEditMode: Bool = false
    @State var refreshInterval: RefreshInterval = PhotoSelectionStore.shared.refreshInterval
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func deleteAction(gridItem: PhotoItemView) {
        if let index = photos.firstIndex(where: { gridItem.image == $0.image }) {
            photos.remove(at: index)
        }
    }
    
    var gearButton: some View {
        Button(action: {
            showSettingsView.toggle()
        }) {
            Image(systemName: "gear")
        }
    }
    
    var applyButton: some View {
        Button("Apply",  action: {
          
            isEditMode.toggle()
            
            PhotoSelectionStore.shared.savePhotos(images: photos)
            WidgetCenter.shared.reloadAllTimelines()
        })
    }
    
    var addImageButton: some View {
        Button(action: {
            self.showCaptureImageView.toggle()
        })
        {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .padding()
        }
    }
    
    
    func navItems() -> some View {
        return Group {
            if self.isEditMode {
                applyButton
            }
            else {
                NavigationLink(
                    destination: PhotoWidgetSettingsView(refreshInterval: $refreshInterval),
                    isActive: $showSettingsView,
                    label: {
                        gearButton
                    })
            }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                    ScrollView {
                            VStack {
                                LazyVGrid(columns: layout, spacing: 20) {
                                    ForEach(photos) { item in
                                        PhotoItemView(image: item.image!,
                                                      editMode: $isEditMode,
                                                      deleteAction: { item in
                                                        self.deleteAction(gridItem: item)
                                                      })
                                    }
                                }
                                .padding(.horizontal)
                                
                                addImageButton
                            }.padding(.top, 20)
                    }
                    .navigationBarTitle("Photo Widget", displayMode: .inline)
                    .navigationBarItems(leading:
                                            Button("Edit", action: {
                                                self.isEditMode.toggle()
                                            }),
                                        trailing: navItems())
            }
            
            if showCaptureImageView {
                CaptureImageView(isShown: $showCaptureImageView) { image, imageName in
                    
                    guard let imageName = imageName else { return }
                    photos.append(PhotoModel(imageFileName: imageName))
                    
                    PhotoSelectionStore.shared.savePhotos(images: photos)
                    
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
