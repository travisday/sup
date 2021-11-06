//
//  AccountViewModel.swift
//  sup
//
//  Created by Travis on 9/16/21.
//

import Foundation
import PhotosUI

class EditAccountViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var name: String = ""
    @Published var errorMessage: String = ""
    
    func updateInfo(userService: UserService, auth: AuthService) -> Void {
        userService.updateInfo(username: self.username, name: self.name)
    }
    
    func uploadProfilePicture(userService: UserService, img: UIImage) -> Void {
        userService.uploadProfilePic(img: img)
    }
        
}
