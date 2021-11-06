//
//  CardView.swift
//  sup
//
//  Created by Travis on 5/26/21.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var user: User
    @EnvironmentObject var userService: UserService
    let pushService = PushService()
    
    var body: some View {
        HStack(alignment: .center) {
            if ( (user.profilePic ?? "") != "") {
//                if #available(iOS 15.0, *) {
//                    AsyncImage(url: URL(string: user.profilePic!))
//                    { image in
//                        image.resizable().aspectRatio(contentMode: .fill)//.rotationEffect(.degrees(90))
//                    } placeholder: {
//                        Color.red
//                    }
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//                    .padding(.all, 10)
//                } else {
                    RemoteImage(url: user.profilePic!)
               // }
            } else {
                Image(systemName: "person.circle.fill")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 100)
                       .padding(.all, 10)
            }
        

            VStack(alignment: .leading) {
                
                Text("@\(user.username ?? "")")
                   .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(Color(UIConfiguration.subtitleColor))
                
                HStack() {
                    VStack(alignment: .leading) {
                        Text("\(user.name ?? "")")
                           .font(.system(size: 16, design: .default))
                           .foregroundColor(Color(UIConfiguration.subtitleColor))

                        HStack() {
                            Image(systemName: "star.fill").font(.system(size: 16.0)).foregroundColor(Color(UIConfiguration.buttonColor))
                            Text("\(String(format: "%.1f", user.score ?? 0))")
                               .font(.system(size: 16, weight: .bold, design: .default))
                               .foregroundColor(Color(UIConfiguration.subtitleColor))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if (userService.user!.sendCount! > 0) {
                            pushService.sendPush(userTo: user, userFrom: userService.user!)
                        } else {
                            print("not enough sups")
                        }

                    }, label: {
                        Image(systemName: "hand.wave.fill").font(.system(size: 40.0)).foregroundColor(Color(UIConfiguration.buttonColor))
                    }).frame(maxWidth: .infinity).padding(.leading, 20)
                    
                }
            }
       }
       .frame(maxWidth: .infinity, alignment: .center)
       .background(Color(.white))
       .modifier(CardModifier())
       .padding(.all, 10)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
   }

}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
