//
//  CalendarEventModel.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//


import EventKit
protocol CalendarManaging {
    func create(eventModel: CalendarEventModel) -> String? //
}
struct CalendarEventModel {
    var title: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

final class CalendarManager: CalendarManaging {
    private let eventStore : EKEventStore = EKEventStore()
    func requestCalendarAccess() {
           switch EKEventStore.authorizationStatus(for: .event) {
           case .notDetermined:
               eventStore.requestAccess(to: .event) { granted, error in
                   if granted {
                       print("Доступ предоставлен")
                   } else {
                       print("Доступ не предоставлен")
                   }
               }
           case .restricted, .denied:
               print("Доступ к календарю запрещен")
           case .authorized:
               print("Доступ к календарю уже предоставлен")
           case .fullAccess:
               print("Доступ полностью разрешён")
           case .writeOnly:
               print("Доступ только на запись")
           @unknown default:
               print("Неизвестный статус доступа")
           }
       }
    func create(eventModel: CalendarEventModel) -> String? {
        var eventIdentifier: String?
        let group = DispatchGroup()
        group.enter()
        create(eventModel: eventModel) { identifier in
            eventIdentifier = identifier
            group.leave()
        }
        group.wait()
        return eventIdentifier
    }

    func create(eventModel: CalendarEventModel, completion: ((String?) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                completion?(nil)
                return
            }
            let event = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.note
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            do {
                try self.eventStore.save(event, span: .thisEvent)
                completion?(event.eventIdentifier) // Возвращаем идентификатор
            } catch let error as NSError {
                print("Failed to save event with error: \(error)")
                completion?(nil)
            }
        }
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
    
    func delete(eventIdentifier: String, completion: ((Bool) -> Void)?) {
        print("Начинаем удаление события с идентификатором: \(eventIdentifier)")
        
        let deleteEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                print("Доступ к календарю не предоставлен или ошибка: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion?(false)
                return
            }
            
            if let event = self.eventStore.event(withIdentifier: eventIdentifier) {
                do {
                    try self.eventStore.remove(event, span: .thisEvent, commit: true)
                    print("Событие удалено: \(eventIdentifier)")
                    completion?(true)
                } catch let error as NSError {
                    print("Ошибка при удалении события: \(error.localizedDescription)")
                    completion?(false)
                }
            } else {
                print("Событие с идентификатором \(eventIdentifier) не найдено.")
                completion?(false)
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: deleteEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: deleteEvent)
        }
    }
}
