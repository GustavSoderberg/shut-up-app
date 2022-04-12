//
//  SingleConversationView.swift
//  ShutUp
//
//  Created by Gustav Söderberg on 2022-03-28.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SingleConversationView: View {
    
    var index: Int
    @ObservedObject var convoM = cm
    @State var conversation: Conversation?
    @State var showSettingsView = false
    var getMembers = GetMembers()
    
    @State var message = ""
    
    var body: some View {
        
        Divider()
        
        ScrollView() {
            
            Spacer()
            
            HStack{
                
                VStack {
                    
                    
                    
                    if !convoM.listOfConversations.isEmpty {
                        
                        ForEach(convoM.listOfConversations[index].messages) { message in
                        
                        
                            
                            MessageBubble(message: message)
                        
                            }
                    }
                        
                            
                        
                        
                        //Text("\(message.timeStamp.formatted()):\n\(message.text)").padding()
                    
                }
                Spacer()
            }
            Spacer()
        }
        
        HStack {
            
            TextField("message", text: $message).padding()
            
            Button {
                
                if !message.isEmpty {
                    convoM.sendMessage(message: message, user: um.currentUser!, conversation: conversation!)
                    message = ""
                }
                
            } label: {
                
                Text("Send")
                
            }.padding()
            
        }.toolbar {
            Button {
                showSettingsView = true
            } label: {
                Image(systemName: "gear")
            }

        }
        .navigationBarTitle("\(getMembers.everybody(members: conversation!.members))".dropLast(2)).navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSettingsView) {
            SettingsView(showSettingsView: $showSettingsView, conversation: conversation!)
        }
        
    }
    
}

struct GetMembers {
    
    func everybody(members: [User]) -> String {
        
        var rMembers = ""

        for member in members {
            
            if member.username != um.currentUser!.username {
                
                rMembers += "\(member.username), "
                
            }
        }
        return rMembers
    }
}

struct MessageBubble : View{
    
    @ObservedObject var convoM = cm
    var message: Message
    
    var body: some View {
        
        VStack(alignment: um.currentUser!.id == message.senderID ? .trailing : .leading){
            
            HStack{
                Text(message.text)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(um.currentUser!.id == message.senderID ? sm.currentTheme!.bubbleS : sm.currentTheme!.bubbleR)
                    .cornerRadius(30)
                
            }
            .frame(maxWidth: 300, alignment: um.currentUser!.id == message.senderID ? .trailing : .leading)
            
        }
        .frame(maxWidth: .infinity, alignment: um.currentUser!.id == message.senderID ? .trailing : .leading)
        .padding(um.currentUser!.id == message.senderID ? .trailing : .leading)

    }
}

