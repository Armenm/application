//
//  EventEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

final class EventEntity: TemplatableObject, TemplateEntity {

  enum EventRegistrationStatus: String {
    case waiting
    case rejected
    case approved
    case unknown

    var allowRegister: Bool {
      switch self {
      case .unknown:
        return true
      case .waiting, .rejected, .approved:
        return false
      }
    }
  }

  dynamic var id: Int = 0

  dynamic var title: String = ""
  dynamic var descriptionText: String = ""

  dynamic var startDate: Date = Date()
  dynamic var endDate: Date = Date()

  dynamic var photoURL: String = ""
  dynamic var status: String = "unknown"
  dynamic var place: PlaceEntity?
  dynamic var isRegistrationOpen: Bool = false

  let speeches = List<SpeechEntity>()
  let speakerPhotosURLs = List<StringContainerEntity>()
  var registrationStatus: EventRegistrationStatus {
    return EventRegistrationStatus(rawValue: status) ?? .unknown
  }
  override static func primaryKey() -> String? {
    return "id"
  }
}

extension EventEntity {
  static var templateEntity: EventEntity {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"

    let entity = EventEntity()
    entity.title = "CocoaHeads Meetup"
    entity.descriptionText = "Совсем скоро в петербургском офисе Яндекса первая встреча сообщества CocoaHeads Russia."
    entity.startDate <= formatter.date(from: "20161111")
    entity.endDate <= formatter.date(from: "20161111")
    entity.photoURL = "https://avatars.mds.yandex.net/get-yaevents/194464/552b2574b7b911e6afd30025909419be/320x240"
    entity.place = PlaceEntity.templateEntity
    entity.status = EventEntity.EventRegistrationStatus.unknown.rawValue
    entity.isRegistrationOpen = false
    entity.speeches.append(SpeechEntity.templateEntity)
    entity.isTemplate = true
    return entity
  }
}
