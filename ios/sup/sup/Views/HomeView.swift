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
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(Color(UIConfiguration.buttonColor))
                            .imageScale(.large)
                    }), trailing: (
                        Button(action: { self.showActivity.toggle()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color(UIConfiguration.buttonColor))
                            .imageScale(.large)})
                )

        }.accentColor(Color(UIConfiguration.subtitleColor))
        .onAppear {
            userService.getCurrentUser(documentId: Auth.auth().currentUser!.uid)
        }
    }
}

struct MainView: View {
    @Binding var showMenu: Bool
    @EnvironmentObject var userService: UserService
    

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
                ForEach(userService.friends, id:\.id) { user in
                    CardView(user:user)
                }
                Spacer()
            }
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
