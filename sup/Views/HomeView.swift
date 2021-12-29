//
//  HomeView.swift
//  sup
//
//  Created by Travis on 5/20/21.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var userService: UserService

    @State var showMenu: Bool = false
    @State var showActivity: Bool = false

    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                self.showMenu = false
                            }
                        }
                    }

        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: ActivityView(), isActive: $showActivity) { EmptyView() }
                    MainView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        Drawer()
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
                    .gesture(drag)
            }
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("SUP!").font(.headline)
                            }
                        }
                    }
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        if (userService.requests_rec.isEmpty) {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(Color(UIConfiguration.buttonColor))
                                .imageScale(.large)
                        } else {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(Color(UIConfiguration.buttonColor))
                                .imageScale(.large)
                                .overlay(Capsule().fill(Color.red).frame(width: 10, height: 10, alignment: .topTrailing).position(x: 25, y: 0))
                        }
                        

                    }), trailing: (
                        Button(action: { self.showActivity.toggle()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color(UIConfiguration.buttonColor))
                            .imageScale(.large)})
                )

        }.accentColor(Color(UIConfiguration.subtitleColor))
        .onAppear {
            userService.friends = [User]()
            userService.events = [Event]()
            userService.requests_sent = [User]()
            userService.requests_rec = [User]()
            userService.getCurrentUser(documentId: Auth.auth().currentUser!.uid)
        }
    }
}

struct MainView: View {
    @Binding var showMenu: Bool
    @EnvironmentObject var userService: UserService
    @State var profileText = userService.user?.profileText ?? "Tell your friends what's up..."
    

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "star.fill").font(.system(size: 24.0)).foregroundColor(Color(UIConfiguration.buttonColor))
                    Text("\(String(format: "%.1f", userService.user?.score ?? 0))").font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(Color(UIConfiguration.subtitleColor))
                        
                    
                }.frame(maxWidth: .infinity)
                HStack {
                    Image(systemName: "hands.sparkles.fill").font(.system(size: 24.0)).foregroundColor(Color(UIConfiguration.buttonColor))
                    Text("\(userService.user?.sendCount ?? 0)").font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(Color(UIConfiguration.subtitleColor))
                        
                }.frame(maxWidth: .infinity)
            }.padding(.top, 14)
            
            ScrollView{
                if (userService.friends.isEmpty) {
                    Spacer()
                    VStack() {
                        Text("You don't have any friends yet!").font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(Color(UIConfiguration.subtitleColor))
                        Text("Open the drawer menu, then go to add friends to search for your friends.").font(.system(size: 18, design: .default))
                            .foregroundColor(Color(UIConfiguration.subtitleColor))
                    }.padding(.all, 20)
                    Spacer()
                } else {
                    ForEach(userService.friends, id:\.id) { user in
                        CardView(user:user)
                    }
                    Spacer()
                }
            }
        }
//        .onTapGesture {
//            self.hideKeyboard()
//        }

    }
}

//#if canImport(UIKit)
//extension View {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//#endif

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
