//
//  ContentView.swift
//  YouMethod
//
//  Created by Dillon Kermani on 1/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appDelegate: AppDelegate
    
    @State var notificationsEnabled = false
    @State var presentAlert = false
    
    let notificationManager = NotificationManager()
    
    var body: some View {
        ZStack {
            Image("milkyway")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Button {
                    presentAlert.toggle()
                } label: {
                    VStack {
                        Text("(Tap to Redirect)")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .padding(.top, 60)
                        
                        Image("ym_cascade")
                            .resizable()
                            .scaledToFit()
                            .padding(140)
                    }
                    
                }
                
                Spacer()
                
                HStack {
                    VStack {
                        Button {
                            openURL(URL(string: "https://www.youmethod.com/#SignUp")!)
                        } label: {
                            customButton(icon: "rectangle.and.pencil.and.ellipsis", label: "Sign Up", width: 160, height: 50, fontsize: 23, color: .black)
                        }
                        Button {
                            openURL(URL(string: "https://www.youmethod.com/#SignIn")!)
                        } label: {
                            customButton(icon: "rectangle.portrait.and.arrow.right", label: "Sign In", width: 160, height: 50, fontsize: 23, color: .black)
                        }
                    }
                    
                    // Spacer not working as expected so using this instead.
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width/3.5, height: 0)
                    VStack {
                        Rectangle()
                            .frame(width: 0, height: 70)
                        notificationToggleButton()
                    }
                    
                }.padding()
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                checkNotificationAuth()
            } else if newPhase == .inactive {
                print("Inactive")
                checkNotificationAuth()
            } else if newPhase == .background {
                print("Background")
                checkNotificationAuth()
            }
        }
        .onAppear() {
            UIApplication.shared.applicationIconBadgeNumber = 0
            presentAlert.toggle()
            checkNotificationAuth()
            
            notificationManager.addLocalNotification(title: "Morning journal", body: "Tap here to self-reflect", hour: 8, minute: 00)
            notificationManager.addLocalNotification(title: "Midday journal", body: "Tap here to self-reflect", hour: 14, minute: 00)
            notificationManager.addLocalNotification(title: "Evening journal", body: "Tap here to self-reflect", hour: 20, minute: 00)
            
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Detail"), object: nil, queue: .main) { (_) in
                openURL(URL(string: "https://www.youmethod.com/")!)
                
            }
        }
        .alert("Open YouMethod?", isPresented: $presentAlert, actions: {
            Button("Open", action: {openURL(URL(string: "https://www.youmethod.com/")!)})
            Button("Cancel", role: .cancel, action: {})

            }, message: {
              Text("Redirect to browser.")
            })
    }
    
    private func notificationToggleButton() -> some View {
        return Button  {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
        } label: {
            customButton(icon: notificationsEnabled ? "bell.fill" : "bell.slash.fill", label: "", width: 60, height: 60, fontsize: 23, color: notificationsEnabled ? .blue : .gray.opacity(0.8))
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
            print("Authorization status: authorized")
            notificationsEnabled = true
        }else {
            notificationManager.requestAuthorization()
            notificationsEnabled = false
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
