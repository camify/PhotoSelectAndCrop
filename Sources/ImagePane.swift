//
//  ImagePane.swift
//  PhotoSelectAndCrop
//
//  Created by Dave Kondris on 18/11/21.
//

import SwiftUI

public struct ImagePane: View {
    
    @State private var isShowingPhotoSelectionSheet = false
    
    @ObservedObject public var imageAttributes: ImageAttributes
    
    @Binding var isEditMode: Bool
    
    var renderingMode: SymbolRenderingMode = .monochrome
    var isInline: Bool = false
    var colors: [Color] = []
    var linearGradient: LinearGradient = LinearGradient(colors: [], startPoint: .topLeading, endPoint: .bottomTrailing)
    var isGradient: Bool = false
    ///A UIImage that is retrieved to be sent to the finalImage and displayed.
    ///It may be retrieved from the originalImage if one has been
    ///saved previously. Or it may be retrieved
    ///from the ImageMoveAndScaleSheet.
    @State private var inputImage: UIImage?
    
    public init(image: ImageAttributes, isEditMode: Binding<Bool>, isInline:Bool) {
        self._imageAttributes = ObservedObject(initialValue: image)
        self._isEditMode = isEditMode
        self.isInline =  isInline
    }
    
    public init(image: ImageAttributes, isEditMode: Binding<Bool>, renderingMode: SymbolRenderingMode, isInline:Bool) {
        self._imageAttributes = ObservedObject(initialValue: image)
        self._isEditMode = isEditMode
        self.renderingMode = renderingMode
        self.isInline =  isInline
    }
    
    public init(image: ImageAttributes, isEditMode: Binding<Bool>, renderingMode: SymbolRenderingMode, colors: [Color], isInline:Bool) {
        self._imageAttributes = ObservedObject(initialValue: image)
        self._isEditMode = isEditMode
        self.renderingMode = renderingMode
        self.isInline =  isInline
        self.colors = []
        for color in colors {
            self.colors.append(color)
        }
    }
    
    public init(image: ImageAttributes, isEditMode: Binding<Bool>, renderingMode: SymbolRenderingMode, linearGradient: LinearGradient, isInline:Bool) {
        self._imageAttributes = ObservedObject(initialValue: image)
        self._isEditMode = isEditMode
        self.renderingMode = renderingMode
        self.linearGradient = linearGradient
        self.isInline =  isInline
        self.isGradient = true
        
    }
    
    private init(addPhotoText: String, changePhotoText: String, image: ImageAttributes, defaultImage: UIImage, isEditMode: Binding<Bool>, isInline:Bool) {
        self._imageAttributes = ObservedObject(initialValue: image)
        self._isEditMode = isEditMode
        self.isInline =  isInline
        
    }
    
    public var body: some View {
        
        VStack {
            displayImage
            if isInline! {
                Button  {
                    self.isShowingPhotoSelectionSheet = true
                }, label: {
                        Text("Update")
                            .font(.footnote)
                            .foregroundColor(Color.accentColor)
                    }   .opacity(isEditMode ? 1.0 : 0.0)
                }
        }
        .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet) {
            ImageMoveAndScaleSheet(imageAttributes: imageAttributes)
        }
    }
    
    ///A View that "displays" the image.
    ///
    /// - Note: This requires the `inputImage` be viable.
    private var displayImage: some View {
        
        imageAttributes.image
            .resizable()
            .symbolRenderingMode(renderingMode)
            .modifier(RenderingForegroundStyle(colors: colors, isGradient: isGradient, linearGradient: linearGradient))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .scaledToFill()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
           // .shadow(radius: (imageAttributes.originalImage == nil) ? 0 : 4)
    }
}

struct ImagePane_Previews: PreviewProvider {

    static var previews: some View {

        let placeholder = ImageAttributes(withSFSymbol: "photo.circle")
        let size = 150.0
        ImagePane(image: placeholder, isEditMode: .constant(true))
            .frame(width: size, height: size, alignment: .center)
            .foregroundColor(.pink.opacity(0.25))
            .padding()
            .previewLayout(.sizeThatFits)
            .background(.white)

        ImagePane(image: placeholder, isEditMode: .constant(false), renderingMode: .palette, colors: [.blue, .white])
            .frame(width: size, height: size, alignment: .center)
            .padding()
            .previewLayout(.sizeThatFits)
            .background(.gray)
        
        ImagePane(image: placeholder, isEditMode: .constant(true), renderingMode: .monochrome, linearGradient: LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: size, height: size, alignment: .center)
            .padding()
            .previewLayout(.sizeThatFits)
            .background(.black)
    }
}
