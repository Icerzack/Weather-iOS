//
//  CardView.swift
//  Weather
//
//  Created by Max Kuznetsov on 26.08.2022.
//

import SwiftUI

struct CardView: View {
    
    var date: String
    var image: Image
    var temperature: Double
    
    var body: some View {
        ZStack {
            Color.back
            VStack{
                Text(date)
                    .foregroundColor(.white)
                image
                Text(String("\(temperature) °C"))
                    .foregroundColor(.white)
            }
        }.frame(width: 100, height: 200, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(date: Date.now.description, image: Image("clear_day"), temperature: 40.3)
    }
}
