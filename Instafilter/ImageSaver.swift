//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Marvin Lee Kobert on 15.04.22.
//

import UIKit

class ImageSaver: NSObject {
  var successHandler: (() -> Void)?
  var errorHandler: ((Error) -> Void)?

  func writeToPhotoAlbum(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
  }

  @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      errorHandler?(error)
    } else {
      successHandler?()
    }
  }
}
