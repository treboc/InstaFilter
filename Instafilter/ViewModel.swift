//
//  ViewModel.swift
//  Instafilter
//
//  Created by Marvin Lee Kobert on 30.04.22.
//

import SwiftUI
import UIKit
import PhotosUI

class ViewModel: ObservableObject {
  @Published var imagePickerIsShown: Bool = false

  @Published var image: Image?
  @Published var inputImage: UIImage?
  @Published var processedImage: UIImage?

  @Published var intensity: Float = 0.5
  @Published var radius: Float = 0.5
  @Published var scale: Float = 0.5
  @Published var typePositionX: CGFloat = 150
  @Published var typePositionY: CGFloat = 150
  var typePosition: CIVector {
    return CIVector(x: typePositionX, y: typePositionY)
  }

  @Published var currentFilter: CIFilter = CIFilter.sepiaTone()

  let context = CIContext()

  var currentFilterKeys: [String] {
    return currentFilter.inputKeys.filter { $0 != kCIInputImageKey }
  }

  var filterName: String {
    var filterName = currentFilter.name
    filterName.removeFirst(2)
    return filterName
  }

  @Published var showingFilterSheet: Bool = false

  func save() {
    guard let processedImage = processedImage else { return }
    let imageSaver = ImageSaver()
    imageSaver.successHandler = {
      print("Successfully saved picture!")
    }

    imageSaver.errorHandler = {
      print("Oups, error \($0.localizedDescription) occured.")
    }

    imageSaver.writeToPhotoAlbum(image: processedImage)
  }

  func loadImage() {
    guard let inputImage = inputImage else { return }
    let beginImage = CIImage(image: inputImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyFilter()
  }

  func applyFilter() {
    let inputKeys = currentFilter.inputKeys

    if inputKeys.contains(kCIInputIntensityKey) {
      currentFilter.setValue(intensity, forKey: kCIInputIntensityKey) }
    if inputKeys.contains(kCIInputRadiusKey) {
      currentFilter.setValue(radius * 200, forKey: kCIInputRadiusKey) }
    if inputKeys.contains(kCIInputScaleKey) {
      currentFilter.setValue(scale * 10, forKey: kCIInputScaleKey) }
    if inputKeys.contains(kCIInputCenterKey) {
      currentFilter.setValue(typePosition, forKey: kCIInputCenterKey)
    }

    guard let outputImage = currentFilter.outputImage else { return }
    if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
      let uiimg = UIImage(cgImage: cgimg)
      image = Image(uiImage: uiimg)
      processedImage = uiimg
    }
  }

  func setFilter(_ filter: CIFilter) {
    self.currentFilter = filter
    loadImage()
  }
}
