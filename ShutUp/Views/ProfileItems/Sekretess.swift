//
//  Sekretess.swift
//  ShutUp
//
//  Created by Yolanda Jonasson on 2022-04-08.
//

import SwiftUI

struct Sekretess: View {

    var body: some View {

        HStack{

            Image(systemName: "hand.raised.circle.fill")
                .font(.system(size: 25))
                .padding()
                .foregroundColor(Color.gray)
            Spacer()
            Text("Sekretess")
                Spacer()
//            Image(systemName: "greaterthan")
//                .padding()

        }
        //.frame(width: 0.95 * UIScreen.main.bounds.width, height: 45)
            .background(Color.white)
            .cornerRadius(10)

    }
}