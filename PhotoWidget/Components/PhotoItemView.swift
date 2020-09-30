//
//  GridImageView.swift
//  PhotoWidget
//
//  Created by Bohdan Kachur on 21.09.2020.
//

import SwiftUI

struct PhotoItemView: View, Identifiable {
    var id = UUID()
    
    @State var image: Image? = nil
    @Binding var editMode: Bool

    var deleteAction: (PhotoItemView) -> Void
    
    var body: some View {
        ZStack {
            image?
                .resizable()
                .frame(minWidth: 0, maxWidth: 150, minHeight: 150, maxHeight: 150)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
            
            if editMode {
            VStack() {
                Button(action: {
                    self.deleteAction(self)
                }) {
                    Image(systemName: "minus.circle.fill").font(.largeTitle)
                }
                .padding()
                .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                .foregroundColor(.red)
                .opacity(0.5)
                Spacer()
            }.frame(maxWidth: .infinity, alignment:.leading)
            }
        }
        .frame(minWidth: 150, maxWidth: 150, maxHeight: 150)
    }
    
}


struct GridImageView_Previews : PreviewProvider {
    @State private static var editMode = false
    static var previews: some View {
        PhotoItemView(image: Image("Image"), editMode: $editMode, deleteAction: { item in
            
        })
    }
}
