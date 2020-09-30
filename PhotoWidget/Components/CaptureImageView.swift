//
//  CaptureImageView.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 21.09.2020.
//

import SwiftUI

struct CaptureImageView {
    
    @Binding var isShown: Bool
    var imageSelected: (Image, String?) -> Void
    
    func makeCoordinator() -> Coordinator {
      return Coordinator(isShown: $isShown, imageSelected: imageSelected)
    }

}

extension CaptureImageView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        
        return picker
    }
    
}
