//
//  SelectedImageModel.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 21.09.2020.
//

import SwiftUI

class PhotoModel: NSObject, Identifiable {
    
    let id = UUID()
    var image: Image? = nil
    var imageFileName: String? = nil
    
    init(imageFileName: String?) {

        self.imageFileName = imageFileName
        
        if image == nil && imageFileName != nil {
            self.image = Image(uiImage: UIImage(data: PhotoSelectionStore.shared.retriveImageData(key: imageFileName!)!)!)
        }
    }
    
    /*required convenience init(coder: NSCoder) {
        let imageName = coder.decodeObject(forKey: "ImageName") as! String
        self.init(nil, imageFileName: imageName)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(imageFileName, forKey: "ImageName")
    }*/
}
