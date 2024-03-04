//
//  DaysBetweenLineChart.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 22/10/22.
//

import Charts
import SwiftUI

struct DaysBetweenLineChart: View {
    @EnvironmentObject var model: MyDatesViewModel
    var datas: [Int] {
        model.datasForDaysBetweenGraph()
    }
    var meanValue: Int {
        let sum = datas.reduce(0,+)
        let mean = sum / datas.count
        return mean
    }
    
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.secondary)
                .frame(width: 50, height: 5)
            Spacer()
            Chart(0..<datas.count, id: \.self) { index in
                PointMark(
                    x: .value("Date", index),
                    y: .value("Days", datas[index])
                )
                .annotation(position: .top) {
                    Text(datas[index], format: .number)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                AreaMark(
                    x: .value("Date", index),
                    y: .value("Days", datas[index])
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.blue.opacity(0.2))
                RuleMark(y: .value("Mean", meanValue))
                    .foregroundStyle(.black)
                    .annotation(alignment: .leading) {
                        Text(meanValue, format: .number)
                    }
            }
            .chartXAxis(.hidden)
        }
        .padding()
    }
}

struct DaysBetweenLineChart_Previews: PreviewProvider {
    static var previews: some View {
        DaysBetweenLineChart()
            .environmentObject(MyDatesViewModel())
    }
}
