//
//  ContentView.swift
//  Instafilter
//
//  Created by Marvin Lee Kobert on 13.04.22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import AVFoundation


struct ContentView: View {
  @StateObject private var vm: ViewModel = ViewModel()

  var body: some View {
    NavigationView {
      VStack {
        ZStack {
          if vm.image == nil {
            RoundedRectangle(cornerRadius: 20)
              .fill(.secondary)

            Text("Tap here to select a photo")
              .font(.headline)
              .foregroundColor(.white)
          }

          vm.image?
            .resizable()
            .scaledToFit()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onTapGesture {
          vm.imagePickerIsShown.toggle()
        }

        Spacer()

        VStack {
          VStack {
            Text("\(vm.filterName)")

            SliderStack(viewModel: vm)
              .disabled(vm.image == nil)
          }
          .padding(.vertical)

          HStack {
            Button("Change filter") {
              vm.showingFilterSheet.toggle()
            }

            Spacer()

            Button("Save", action: vm.save)
              .disabled(vm.image == nil)
          }
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(.tertiary)
        )
//        .frame(maxWidth: .infinity, alignment: .bottom)


      }
      .padding([.horizontal, .bottom])
      .sheet(isPresented: $vm.imagePickerIsShown, content: {
        ImagePicker(image: $vm.inputImage)
      })
      .navigationTitle("Instafilter")
      .onChange(of: vm.inputImage) { _ in vm.loadImage() }
      .confirmationDialog("Select a filter", isPresented: $vm.showingFilterSheet) {
        Button("Crystallize") { vm.setFilter(CIFilter.crystallize()) }
        Button("Edges") { vm.setFilter(CIFilter.edges()) }
        Button("Guassian Blur") { vm.setFilter(CIFilter.gaussianBlur()) }
        Button("Pixellate") { vm.setFilter(CIFilter.pixellate()) }
        Button("Sepia Tone") { vm.setFilter(CIFilter.sepiaTone()) }
        Button("Unsharp Mask") { vm.setFilter(CIFilter.unsharpMask()) }
        Button("Vignette") { vm.setFilter(CIFilter.vignette()) }
        Button("Bloom") { vm.setFilter(CIFilter.bloom()) }
        Button("Pointillize") { vm.setFilter(CIFilter.pointillize()) }
        Button("BumpDistortion") { vm.setFilter(CIFilter.bumpDistortion()) }
//        Button("Cancel", role: .cancel) {  }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct SliderStack: View {
  @StateObject var viewModel: ViewModel

  var body: some View {
    VStack {
      if viewModel.currentFilterKeys.contains(kCIInputIntensityKey) {
        HStack {
          Text("Intensity")
            .frame(maxWidth: 100, alignment: .leading)
          Slider(value: $viewModel.intensity)
            .onChange(of: viewModel.intensity) { _ in viewModel.applyFilter() }
        }
      }

      if viewModel.currentFilterKeys.contains(kCIInputRadiusKey) {
        HStack {
          Text("Radius")
            .frame(maxWidth: 100, alignment: .leading)
          Slider(value: $viewModel.radius, in: 0.1...1)
            .onChange(of: viewModel.radius) { _ in viewModel.applyFilter() }
        }
      }

      if viewModel.currentFilterKeys.contains(kCIInputScaleKey) {
        HStack {
          Text("Scale")
            .frame(maxWidth: 100, alignment: .leading)
          Slider(value: $viewModel.scale)
            .onChange(of: viewModel.scale) { _ in viewModel.applyFilter() }
        }
      }

      if viewModel.currentFilterKeys.contains(kCIInputCenterKey) {
        HStack {
          Text("Type Position")
            .frame(maxWidth: 100, alignment: .topLeading)
          VStack {
            HStack {
              Text("X")
              Slider(value: $viewModel.typePositionX, in: 1...300)
            }
            HStack {
              Text("Y")
              Slider(value: $viewModel.typePositionY, in: 1...300)
            }
          }
          .onChange(of: viewModel.typePosition) { _ in viewModel.applyFilter() }
        }
      }
    }
  }
}
