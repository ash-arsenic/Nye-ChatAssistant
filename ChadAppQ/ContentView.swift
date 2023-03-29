//
//  ContentView.swift
//  ChadAppQ
//
//  Created by Rapipay Macintoshn on 24/03/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var setttings: UserSettings
    var body: some View {
        NavigationView {
            if setttings.user.username != "User-name" {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
