//
//  ContentView.swift
//  YouMethod
//
//  Created by Dillon Kermani on 1/11/23.
//

import SwiftUI
import BetterSafariView

struct MainControls {
    var notificationsEnabled = false
    var presentAlert = false
    var safariViewShowing = false
    var safariUrl = "https://youmethod.com/"
}

struct ContentView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appDelegate: AppDelegate
    
    @State var controls = MainControls()

    let notificationManager = NotificationManager()
    
    var body: some View {
        ZStack {
            Image("milkyway")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Button {
                    controls.presentAlert.toggle()
                } label: {
                    VStack {
                        Text("(Tap to Open)")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .padding(.top, 60)
                        
                        Image("ym_cascade")
                            .resizable()
                            .scaledToFit()
                            .padding([.bottom, .leading, .trailing], 150)
                            .padding(.top, 60)
                        Spacer()
                    }
                    
                }
                
                HStack {
                    notificationToggleButton()
                }.padding(50)
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                //print("Active")
                checkNotificationAuth()
            } else if newPhase == .inactive {
                //print("Inactive")
                checkNotificationAuth()
            } else if newPhase == .background {
                //print("Background")
                checkNotificationAuth()
            }
        }
        .onAppear() {
            UIApplication.shared.applicationIconBadgeNumber = 0
            controls.presentAlert.toggle()
            checkNotificationAuth()
            
            notificationManager.deleteLocalNotifications()
            
            notificationManager.addLocalNotification(title: "Morning reflection 🌱🌞", body: "Take a moment to check in with You", hour: 8, minute: 00)
            
            notificationManager.addLocalNotification(title: "Afternoon reflection 🌎💫", body: "Take a moment to check in with You ", hour: 14, minute: 00)
            notificationManager.addLocalNotification(title: "Evening reflection 🌒✨", body: "Take a moment to check in with You", hour: 20, minute: 00)
            
            
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Detail"), object: nil, queue: .main) { (_) in
                openURL(URL(string: "https://www.youmethod.com/")!)
                
            }
        }
        .alert("Open YouMethod?", isPresented: $controls.presentAlert, actions: {
            Button("Open", action: {
                controls.safariViewShowing.toggle()
            })
            Button("Cancel", role: .cancel, action: {})

            }, message: {
              Text("Open in browser.")
            })
        .safariView(isPresented: $controls.safariViewShowing) {
                    SafariView(
                        url: URL(string: controls.safariUrl)!,
                        configuration: SafariView.Configuration(
                            entersReaderIfAvailable: false,
                            barCollapsingEnabled: true
                        )
                    )
                    .preferredBarAccentColor(.white)
                    .preferredControlAccentColor(.accentColor)
                    .dismissButtonStyle(.done)
        }

    }
    
    private func notificationToggleButton() -> some View {
        return Button  {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
        } label: {
            customButton(icon: controls.notificationsEnabled ? "bell.fill" : "bell.slash.fill", label: "", width: 80, height: 80, fontsize: 35, color: controls.notificationsEnabled ? .blue : .gray.opacity(0.8)).cornerRadius(25)
        }
    }
    
    private func customButton(icon: String, label: String, width: CGFloat, height: CGFloat, fontsize: CGFloat, color: Color) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .cornerRadius(15)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                    .font(.system(size: fontsize))
                if (!label.isEmpty) {
                    Text(label)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .font(.system(size: fontsize))
                }
            }
        }
    }
    func checkNotificationAuth() {
        notificationManager.reloadAuthorizationStatus()
        notificationManager.requestAuthorization()
        if notificationManager.authorizationStatus == .authorized {
            controls.notificationsEnabled = true
        }else {
            notificationManager.requestAuthorization()
            controls.notificationsEnabled = false
        }
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


