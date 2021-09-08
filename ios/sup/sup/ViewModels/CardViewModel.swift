//
//  CardViewModel.swift
//  sup
//
//  Created by Travis on 9/2/21.
//

import Foundation
import Combine

// 1
class CardViewModel: ObservableObject, Identifiable {
  // 2
  private let friendService = FriendService()
  @Published var user: User
  // 3
  private var cancellables: Set<AnyCancellable> = []
  // 4
  var id = ""

  init(user: User) {
    self.user = user
    // 5
    $user
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
  }
}
