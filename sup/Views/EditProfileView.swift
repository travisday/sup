//
//  EditProfileView.swift
//  sup
//
//  Created by Travis on 9/16/21.
//

import SwiftUI
import MobileCoreServices
import PhotosUI
import AVKit

struct EditProfileView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var auth: AuthService
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private var viewModel: EditAccountViewModel
    @State private var showingImagePicker: Bool = false
    @State private var inputImage: UIImage?
    
    init() {
        self.viewModel = EditAccountViewModel()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 30) {
                
                VStack(alignment: .center, spacing: 5) {
                
                    Button(action: {showingImagePicker = true }) {
                        if (inputImage == nil) {
                            if ((userService.user?.profilePic ?? "") != "") {

                                RemoteImage(url: userService.user!.profilePic!)
                                
                            } else {
                                Image(systemName: "person.circle.fill")
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 200)
                                       .padding(.all, 20)
                            }
                        } else {
                            Image(uiImage: inputImage ?? UIImage())
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .offset(y: 15)
                                .padding(.all, 20)
                        }
                
                       
                    }
                    Text("Tap to change image")
                }.sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: self.$inputImage)
                  }
                
                VStack(alignment: .center, spacing: 25) {
                    Text("Username").modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.tintColor))
                    CustomTextField(placeHolderText: "Username",
                                  text: $viewModel.username)
                    Text("Name").modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.tintColor))
                    CustomTextField(placeHolderText: "Name",
                                  text: $viewModel.name)
                    
                }
                .padding(.horizontal, 25)
                
                Text(self.viewModel.errorMessage)
                    .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                        color: UIConfiguration.tintColor))
                Spacer()
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) { Text("Cancel").foregroundColor(Color(UIConfiguration.tintColor))},
                trailing:
                    Button(action: {
                        self.updateInfo()
                        self.updatePic()
                        self.presentationMode.wrappedValue.dismiss()
                }) { Text("Save").foregroundColor(Color(UIConfiguration.tintColor))})
            .accentColor(Color(UIConfiguration.tintColor))
            
        }
        .onAppear {
            self.viewModel.username = userService.user!.username!
            self.viewModel.name = userService.user!.name!
        }
    }
    
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//    }
    
    func updateInfo() {
        self.viewModel.updateInfo(userService: userService, auth: auth)
    }
    
    private func updatePic() {
        if (inputImage != nil) {
            self.viewModel.uploadProfilePicture(userService: userService, img:inputImage ?? UIImage())
        }
    }
}

//class photoCoordinator:PHPickerViewControllerDelegate{
//    private let parent: PhotoPicker
//    init(_ parent: PhotoPicker) {
//        self.parent = parent
//    }
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        parent.pickerResult.removeAll() // remove previous pictures from the main view
//
//          // unpack the selected items
//          for image in results {
//            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
//              image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
//                if let error = error {
//                  print("Can't load image \(error.localizedDescription)")
//                } else if let image = newImage as? UIImage {
//                  // Add new image and pass it back to the main view
//                  self?.parent.pickerResult.append(image)
//                }
//              }
//            } else {
//              print("Can't load asset")
//            }
//          }
//       let accessLevel: PHAccessLevel = .readWrite
//        let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)
//        if(status == .notDetermined){
//            PHPhotoLibrary.requestAuthorization(for: accessLevel){ newStatus in
//                switch newStatus {
//                case .limited:
//                    print("Limited access.")
//                    break
//                case .authorized:
//                    print("Full access.")
//                case .denied:
//                    break
//                default:
//                    break
//                }
//            }
//        }
//          // close the modal view
//          parent.isPresented = false
//        }
//}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    @Binding var image: UIImage? // pass images back to the SwiftUI view
    //@Binding var isPresented: Bool // close the modal view
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


