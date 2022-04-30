//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Marvin Lee Kobert on 13.04.22.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  @Binding var image: UIImage?

  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)

      guard let provider = results.first?.itemProvider else { return }

      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { image, _ in
          DispatchQueue.main.async {
            self.parent.image = image as? UIImage
          }
        }
      }
    }
  }

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images

    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    //
  }
}
