//
//  ViewController.swift
//  CalendarKit Test
//
//  Created by anthony byrd on 6/16/21.
//

import UIKit
import CalendarKit
import EventKit

class CalendarViewController: DayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Calendar"
        requestAccessToCalendar()
        subscribeToNotifications()
    }
    
    //MARK: - Properties
    private let eventStore = EKEventStore()
    
    //MARK: - Methods
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { success, error in

        }
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: nil)
    }
    
    @objc func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map { ekEvent -> Event in
            let ckEvent = Event()
            ckEvent.startDate = ekEvent.startDate
            ckEvent.endDate = ekEvent.endDate
            ckEvent.isAllDay = ekEvent.isAllDay
            ckEvent.text = ekEvent.title
            
            if let eventColor = ekEvent.calendar.cgColor {
                ckEvent.color = UIColor(cgColor: eventColor)
            }
            return ckEvent
        }
        return calendarKitEvents
    }

}//End of class

