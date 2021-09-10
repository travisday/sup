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
        Image(systemName: "person.circle.fill")
               .resizable()
               .aspectRatio(contentMode: .fit)
               .frame(width: 100)
               .padding(.all, 20)

            VStack(alignment: .leading) {
                Text(user.displayName ?? "")
                   .font(.system(size: 26, weight: .bold, design: .default))
                .foregroundColor(Color(UIConfiguration.subtitleColor))
                Text("\(String(format: "%.1f", user.score ?? 0))")
                   .font(.system(size: 16, weight: .bold, design: .default))
                   .foregroundColor(Color(UIConfiguration.subtitleColor))
            }.padding(.trailing, 20)
        Button(action: {
            pushService.sendPush(userTo: user, userFrom: userService.user!)

        }, label: {
            Image(systemName: "hands.sparkles.fill").font(.system(size: 56.0)).foregroundColor(Color(UIConfiguration.buttonColor))
        }).frame(maxWidth: .infinity)
           Spacer()
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
