//
//  EventList.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 18/10/22.
//

import SwiftUI

struct EventList: View {
    @EnvironmentObject var model: MyDatesViewModel
    @State private var showingChart = false
    
    var dates: [Date] {
        model.myDates.listOfEvents
    }
    
    var body: some View {
        List {
            ForEach(0..<dates.count, id:\.self) { index in
                HStack {
                    Text(dates[index].formatted(date: .complete, time: .omitted))
                    Spacer()
                    Text("\(model.myDates.calcDaysBetweenEvents(index: index)) days")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            .onDelete(perform: deleteRow)
        }
        .navigationTitle("Event list")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingChart = true
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
        }
        .sheet(isPresented: $showingChart) {
            DaysBetweenLineChart()
        }
    }
    
    func deleteRow(at offsets: IndexSet) {
        model.myDates.listOfEvents.remove(atOffsets: offsets)
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventList()
                .environmentObject(MyDatesViewModel())
            .environment(\.locale, .init(identifier: "en-GB"))
        }
        NavigationStack {
            EventList()
                .environmentObject(MyDatesViewModel())
            .environment(\.locale, .init(identifier: "es"))
        }
    }
}
