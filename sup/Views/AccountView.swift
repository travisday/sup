//
//  AccountView.swift
//  sup
//
//  Created by Travis on 5/21/21.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var auth: AuthService
    @State var editProfile = false

    
    var body: some View {
       
            
            VStack(alignment: .center, spacing: 30) {
                
                if ( (userService.user?.profilePic ?? "") == "") {
                    Image(systemName: "person.circle.fill")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 100)
                       .padding(.all, 20)
                } else {
//                    if #available(iOS 15.0, *) {
//                        AsyncImage(url: URL(string: userService.user!.profilePic!))
//                        { image in
//                            image.resizable().aspectRatio(contentMode: .fill)//.rotationEffect(.degrees(90))
//                        } placeholder: {
//                            Color.red
//                        }
//                        .frame(maxWidth: 200, maxHeight: 200)
//                        .clipShape(Circle())
//                    } else {
                        RemoteImage(url: userService.user!.profilePic!)
                    //}
                }
            }
            VStack(alignment: .leading, spacing: 30) {
                   
                HStack {
                    Text("Username: ")
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.tintColor))
                        .padding(.leading, 10)
                    Text("\(userService.user?.username ?? "")").modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                                                             color: UIConfiguration.noTint))
                }
                
                HStack {
                
                    Text("Name: ")
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.tintColor))
                        .padding(.leading, 10)
                    Text("\(userService.user?.name ?? "")").modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                                                             color: UIConfiguration.noTint))
                }
                
                HStack {
                    Text("Email: ")
                        .modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                               color: UIConfiguration.tintColor))
                        .padding(.leading, 10)
                    Text("\(userService.user?.email ?? "")").modifier(TextModifier(font: UIConfiguration.subtitleFont,
                                                                             color: UIConfiguration.noTint))
                }
                
                
                Spacer()
                CustomButton(title: "Edit",
                             font: UIConfiguration.buttonFont,
                             color: UIConfiguration.buttonColor,
                             textColor: .white,
                             width: 275,
                             height: 45,
                             action: {self.editProfile.toggle()} )
                    .sheet(isPresented: self.$editProfile,
                           content: { EditProfileView() })
                
            }.navigationBarTitle("Profile", displayMode: .inline)
            .padding(.all, 20)
    }
    
    
}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
