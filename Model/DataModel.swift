//
//  DataModel.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 12/3/22.
//

import SwiftUI

struct MyDatesModel: Codable {
    var lastEventDateModel: Date
    var lastQueryDateModel: Date
    var loadedEventMax: Int
    var loadedQueryMax: Int
    var listOfEvents: [Date]
    
    static let example = MyDatesModel(lastEventDateModel: .now, lastQueryDateModel: .now, loadedEventMax: 0, loadedQueryMax: 0, listOfEvents: [])
}

extension MyDatesModel {
    var sinceLastEvent: Int {
        let seconds = Date.now.timeIntervalSince(lastEventDateModel)
        let days = Int(seconds / 86400)
        return days
    }
    var sinceLastQuery: Int {
        let seconds = Date.now.timeIntervalSince(lastQueryDateModel)
        let days = Int(seconds / 86400)
        return days
    }
    
    mutating func lastEventMaxCalc() -> Int {
        if loadedEventMax >= sinceLastEvent {
            return loadedEventMax
        } else {
            loadedEventMax = sinceLastEvent
            return sinceLastEvent
        }
    }
    mutating func lastQueryMaxCalc() -> Int {
        if loadedQueryMax >= sinceLastQuery {
            return loadedQueryMax
        } else {
            loadedQueryMax = sinceLastQuery
            return sinceLastQuery
        }
    }
    
    func calcDaysBetweenEvents(index: Int) -> Int {
        if index+1 < listOfEvents.count {
            let seconds = listOfEvents[index].timeIntervalSince(listOfEvents[index+1])
            let days = Int(seconds / 86400)
            return days
        }
        return 0
    }
}

final class MyDatesViewModel: ObservableObject {
    @Published var myDates: MyDatesModel {
        didSet {
            save()
        }
    }
    
    private let savingFile = "ALLMYDATES.json"
    
    init() {
        guard var url = Bundle.main.url(forResource: savingFile, withExtension: nil),
              let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            myDates = MyDatesModel.example
            return
        }
        
        let fileURL = path.appendingPathComponent(savingFile)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            url = fileURL
            print(fileURL.absoluteString)
        }
        do {
            let jsonData = try Data(contentsOf: url)
            myDates = try JSONDecoder().decode(MyDatesModel.self, from: jsonData)
        } catch {
            myDates = MyDatesModel.example
            print("Error with loading: \(error)")
        }
    }
    
    func save() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = path.appendingPathComponent(savingFile)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(myDates)
            try data.write(to: fileURL, options: .atomic)
            print(fileURL.absoluteString)
        } catch {
            print("Error with saving: \(error)")
        }
    }
    
    func datesForBarChart(selection num: Int) -> [Date] {
        let last = myDates.lastEventDateModel
        switch num {
        case 0:
            let first = last.addingTimeInterval(-3600*24*6)
            return myDates.listOfEvents.filter { $0 <= last && $0 >= first }
        case 1:
            let first = last.addingTimeInterval(-3600*24*29)
            return myDates.listOfEvents.filter { $0 <= last && $0 >= first }
        case 2:
            let first = last.addingTimeInterval(-3600*24*182)
            return myDates.listOfEvents.filter { $0 <= last && $0 >= first }
        default:
            let first = last.addingTimeInterval(-3600*24*365)
            return myDates.listOfEvents.filter { $0 <= last && $0 >= first }
        }
    }
    
    func lowLimitForXAxis(selection num: Int) -> Date {
        let last = myDates.lastEventDateModel
        switch num {
        case 0:
            return last.addingTimeInterval(-3600*24*7)
        case 1:
            return last.addingTimeInterval(-3600*24*30)
        case 2:
            return last.addingTimeInterval(-3600*24*183)
        default:
            return last.addingTimeInterval(-3600*24*366)
        }
    }
    
    func upLimitForXAxis(selection num: Int) -> Date {
        let last = myDates.lastEventDateModel
        switch num {
        case 0:
            return last.addingTimeInterval(3600*24)
        case 1:
            return last.addingTimeInterval(3600*24)
        case 2:
            return last.addingTimeInterval(3600*24*32)
        default:
            return last.addingTimeInterval(3600*24*32)
        }
    }
    
    func datasForDaysBetweenGraph() -> [Int] {
        var array: [Int] = []
        for i in 0..<myDates.listOfEvents.count {
            let num = myDates.calcDaysBetweenEvents(index: i)
            array.insert(num, at: 0)
        }
        
        return array
    }
}
