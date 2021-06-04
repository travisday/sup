//
//  AddFriendsView.swift
//  sup
//
//  Created by Travis on 5/26/21.
//

import SwiftUI

struct AddFriendsView: View {
    @ObservedObject private var viewModel: AddFriendsViewModel
    @EnvironmentObject var userService: UserService
    @State private var value: String = ""
    @State var users: [User] = []
    @State var isLoading = false
    
    init() {
        self.viewModel = AddFriendsViewModel()
    }
    
    func searchUsers () {
        isLoading = true
        UserSearchService.searchUsers(input: value) { (users) in
            self.isLoading = false
            self.users = users
        }
    }
    
    func isRequested(user:User) -> Bool {
        if userService.requests_sent.firstIndex(of: user) == nil {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        ForEach(userService.requests_rec, id:\.id) { user in
            HStack(alignment: .center) {
                Image(systemName: "person").foregroundColor(Color(UIConfiguration.buttonColor))
                Text("\(user.displayName ?? "")").fontWeight(.bold)
                Spacer()
                Button(action: { viewModel.acceptRequest(reqUser: user, userService: userService) }) {
                    Text("Accept")
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIConfiguration.buttonColor))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .overlay(
                            Capsule(style: .continuous)
                            .stroke(Color(UIConfiguration.buttonColor), lineWidth: 3)
                        )
                }
            }.frame(maxWidth: .infinity, alignment: .center)
            .background(Color(.white))
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
            .padding(.top, 10)
            
            Divider()
        }
        SearchBar(text: $value).padding()
            .onChange(of: value, perform: {new in
                searchUsers()
            })
        ScrollView {
            VStack {
                
                Divider()
                
                if !isLoading {
                    ForEach(users, id:\.id) { user in
                        HStack(alignment: .center) {
                            Image(systemName: "person").foregroundColor(Color(UIConfiguration.buttonColor))
                            Text("\(user.displayName ?? "")").fontWeight(.bold)
                            Spacer()
                            Button(action: { viewModel.sendRequest(reqUser: user, userService: userService) }) {
                                if(isRequested(user: user)) {
                                    Text("Requested")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(UIConfiguration.buttonColor))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .overlay(
                                            Capsule(style: .continuous)
                                            .stroke(Color(UIConfiguration.buttonColor), lineWidth: 3)
                                        )
                                    
                                } else {
                                    Text("Request")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(UIConfiguration.buttonColor))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .overlay(
                                            Capsule(style: .continuous)
                                            .stroke(Color(UIConfiguration.buttonColor), lineWidth: 3)
                                        )
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(.white))
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                        
                        Divider()
                    }
                }
            }

        }.navigationBarTitle("Add Friends")
    }
}

struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView()
    }
}
