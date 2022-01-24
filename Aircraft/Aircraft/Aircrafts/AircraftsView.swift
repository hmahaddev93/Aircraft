//
//  ContentView.swift
//  Aircraft
//
//  Created by Khateeb H. on 1/23/22.
//

import SwiftUI

struct AircraftsView: View {
    @ObservedObject var viewModel:AircraftsViewModel = AircraftsViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.aircrafts, id: \.code) { aircraft in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(aircraft.make)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                        Text(aircraft.model)
                            .font(.system(size: 14, weight: .regular, design: .default))
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Aircrafts")
            .onAppear(perform: {
                viewModel.fetchAircrafts()
            })
            .alert(isPresented: viewModel.isPresentingAlert, content: {
                Alert(title: Text("Error"),
                      message: Text(viewModel.activeError!.localizedDescription),
                      dismissButton: .cancel())
            })
        }
    }
}
