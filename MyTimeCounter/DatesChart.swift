//
//  DatesChart.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 18/10/22.
//

import Charts
import SwiftUI

struct DatesChart: View {
    @EnvironmentObject var model: MyDatesViewModel
    @State private var pickerSelection = 0
    
    let pickerTitles: [LocalizedStringKey] = ["Week", "Month", "6M", "Year"]
    
    var comp: Calendar.Component {
        switch pickerSelection {
        case 0:
            return .weekday
        case 1:
            return .day
        case 2:
            return .month
        default:
            return .month
        }
    }
    
    var datas: [Date] {
        model.datesForBarChart(selection: pickerSelection)
    }
    
    var axisLowLimit: Date {
        model.lowLimitForXAxis(selection: pickerSelection)
    }
    var axisUpLimit: Date {
        model.upLimitForXAxis(selection: pickerSelection)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                Picker("Time selection", selection: $pickerSelection.animation(.easeInOut)) {
                    ForEach(0..<pickerTitles.count, id: \.self) { index in
                        Text(pickerTitles[index])
                    }
                }
                .pickerStyle(.segmented)
                Text("\(datas.count) \(datas.count == 1 ? "Event" : "Events")")
                    .font(.title)
                Chart(datas.reversed(), id: \.self) { data in
                    BarMark(
                        x: .value("Date", data, unit: comp),
                        y: .value("Times", 1)
                    )
                    .foregroundStyle(.red)
                }
                .chartXScale(domain: axisLowLimit...axisUpLimit)
            }
            .frame(height: 500)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 2)))
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Events in time")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DatesChart_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DatesChart()
                .environmentObject(MyDatesViewModel())
                .environment(\.locale, .init(identifier: "en-GB"))
        }
        NavigationStack {
            DatesChart()
                .environmentObject(MyDatesViewModel())
                .environment(\.locale, .init(identifier: "es"))
        }
    }
}
