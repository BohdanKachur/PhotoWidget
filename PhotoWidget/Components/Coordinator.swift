//
//  Coordinator.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 21.09.2020.
//

import SwiftUI
import UIKit

class Coordinator:NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    
    var imageSelected: (Image, String?) -> Void

    init(isShown: Binding<Bool>, imageSelected: @escaping (Image, String?) -> Void) {
        
        _isCoordinatorShown = isShown
        self.imageSelected = imageSelected
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
       guard let unwrapImageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL else { return }
       
        let fileName = unwrapImageURL.lastPathComponent
        let data = unwrapImage.jpegData(compressionQuality: 0.5)! as NSData
        
        PhotoSelectionStore.shared.storeImageData(data:data, for: fileName!)
        self.imageSelected(Image(uiImage: unwrapImage), fileName)
        
       isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       isCoordinatorShown = false
    }
    
}
