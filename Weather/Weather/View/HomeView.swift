//
//  HomeView.swift
//  Weather
//
//  Created by Max Kuznetsov on 26.08.2022.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewVM()
    
    var body: some View {
        ZStack{
            Image("back")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
            VStack {
                VStack(spacing: -10){
                    viewModel.currentWeatherImage?
                        .resizable()
                        .frame(width: 75, height: 75)
                        .padding()
                    Text("Saint-Petersburg")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    Text("\(String(viewModel.currentTemperature ?? 0.0))  °C")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.top, 60)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(){
                        ForEach(viewModel.weatherForecast.indices, id: \.self){ index in
                            if let forecast = viewModel.weatherForecast {
                                CardView(date: forecast[index].0, image: forecast[index].1, temperature: forecast[index].2)
                                    .padding(EdgeInsets(top: 10, leading:10, bottom: 10, trailing: 10))
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading:20, bottom: 150, trailing: 20))
            }
        }
        .onAppear {
            viewModel.fetchWeather()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
