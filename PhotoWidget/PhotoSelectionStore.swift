//
//  PhotoSelectionStore.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 22.09.2020.
//

import SwiftUI


public enum RefreshInterval: String, CaseIterable, Identifiable {
     case never       = "never"
     case fiveMins    = "5 minutes"
     case tenMins     = "10 minutes"
     case thirtyMins  = "30 minutes"
     case hour        = "1 hour"
     
    public var id: String { self.rawValue }
     
     var minutesInterval : Int {
         switch self {
             case .never:
                 return 0
             case .fiveMins:
                 return 5
             case .tenMins:
                 return 10
             case .thirtyMins:
                 return 30
         case .hour:
                 return 60
         }
     }
 }

class PhotoSelectionStore {
    
    static let PHOTOS_KEY = "photos"
    static let REFRESH_INTERVAL_KEY = "refresh_interval"
    static let shared = PhotoSelectionStore()
    
    
    private init() {
   
    }
    
    var refreshInterval: RefreshInterval {
        set(interval) {
            let userDefaults = UserDefaults(suiteName: "group.photowidget.photos")
            userDefaults!.setValue(interval.rawValue, forKey: PhotoSelectionStore.REFRESH_INTERVAL_KEY)
            userDefaults!.synchronize()
        }
        
        get {
            let userDefaults = UserDefaults(suiteName: "group.photowidget.photos")
            if let refreshIntervalRaw = userDefaults?.string(forKey: PhotoSelectionStore.REFRESH_INTERVAL_KEY) {
                return RefreshInterval(rawValue: refreshIntervalRaw) ?? .never
            }
            
            return .never
        }
    }
    
    func savePhotos(images: [PhotoModel])  {
        let userDefaults = UserDefaults(suiteName: "group.photowidget.photos")
        
        let imageNames = images.compactMap({ $0.imageFileName })
        
        userDefaults!.set(imageNames, forKey: PhotoSelectionStore.PHOTOS_KEY)
        userDefaults!.synchronize()
    }
    
    func loadPhotos() -> [PhotoModel] {
        let userDefaults = UserDefaults(suiteName: "group.photowidget.photos")
    
        if let photos = userDefaults?.array(forKey: PhotoSelectionStore.PHOTOS_KEY) {
            return photos.compactMap({ PhotoModel(imageFileName: $0 as? String) })
        }

        return []
    }
    
    func storeImageData(data: NSData, for imageIdentifier: String) {
        let userDefaults = UserDefaults(suiteName: "group.photowidget.photos")
        userDefaults?.setValue(data, forKey: imageIdentifier)
        userDefaults?.synchronize()
    }
    
    func retriveImageData(key: String) -> Data? {
        let userDefaults = UserDefaults(suiteName: "group.photowidget.photos")
        if let data = userDefaults?.data(forKey: key) {
            return data
        }
        return nil
    }
}
