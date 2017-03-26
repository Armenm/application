//
//  RegistrationFormDataCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol FormDisplayCollectionDelegate: class {
  func formDisplayRequestTo(selectItemsAt selectionIndexPaths: [IndexPath],
                            deselectItemsAt deselectIndexPaths: [IndexPath])
  func formDisplayRequestCell(at indexPath: IndexPath) -> UITableViewCell?
  func formDisplayRequestTouchGeuster(enable: Bool)
}

final class FormDisplayCollection: NSObject, DisplayCollection, DisplayCollectionAction {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [OptionTableViewCellModel.self, TextFieldPlateTableViewCellModel.self]
  }

  init(formData: FormData? = nil) {
    self.formData = formData
  }

  var formData: FormData!
  weak var delegate: FormDisplayCollectionDelegate?

  var numberOfSections: Int {
    return formData?.sections.count ?? 0
  }

  func numberOfRows(in section: Int) -> Int {
    return formData.sections[section].fieldAnswers.count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let section = formData.sections[indexPath.section]
    let answerCell = section.fieldAnswers[indexPath.row]

    let (boolAnswer, stringAnswer) = answerCell.answer.pasrseAnswers()

    switch section.type {
    case .checkbox:
      return OptionTableViewCellModel(id: answerCell.id, text: answerCell.value, type: .checkbox, result: boolAnswer)
    case .radio:
      return OptionTableViewCellModel(id: answerCell.id, text: answerCell.value, type: .radio, result: boolAnswer)
    case .string:
      return TextFieldPlateTableViewCellModel(value: stringAnswer,
                                              placeholder: answerCell.value,
                                              textFieldDelegate: self,
                                              valueChanged: { [weak answerCell] value in
        answerCell?.answer = .string(value: value)
      })
    }
  }

  func headerHeight(for section: Int) -> CGFloat {
    return 40
  }

  func headerTitle(for section: Int) -> String {
    return formData.sections[section].name
  }

  func didSelect(indexPath: IndexPath) {
    let section = formData.sections[indexPath.section]
    let answerCell = section.fieldAnswers[indexPath.row]

    let (boolAnswer, _) = answerCell.answer.pasrseAnswers()

    switch section.type {
    case .checkbox:
      answerCell.answer = .selection(isSelected: !boolAnswer)
      processCheckbox(at: indexPath, with: boolAnswer)
    case .radio:
      answerCell.answer = .selection(isSelected: true)
      processRadio(at: indexPath, with: boolAnswer)
    case .string:
      delegate?.formDisplayRequestTo(selectItemsAt: [], deselectItemsAt: [indexPath])
      let cell = delegate?.formDisplayRequestCell(at: indexPath)
      if let cell = cell as? TextFieldPlateTableViewCell {
        cell.textField.becomeFirstResponder()
      }
    }
  }

  private func processCheckbox(at indexPath: IndexPath, with value: Bool) {
    if value {
      delegate?.formDisplayRequestTo(selectItemsAt: [], deselectItemsAt: [indexPath])
    } else {
      delegate?.formDisplayRequestTo(selectItemsAt: [indexPath], deselectItemsAt: [])
    }
  }

  private func processRadio(at indexPath: IndexPath, with value: Bool) {
    var deselectIndex: Int?

    for (index, value) in formData.sections[indexPath.section].fieldAnswers.enumerated() {
      let result = value.answer.pasrseAnswers().0
      if result == true, index != indexPath.row {
        deselectIndex = index
      }
    }

    var deselectIndexPaths: [IndexPath] = []
    if let index = deselectIndex {
      deselectIndexPaths.append(IndexPath(row: index, section: indexPath.section))
    }

    delegate?.formDisplayRequestTo(selectItemsAt: [indexPath], deselectItemsAt: deselectIndexPaths)
  }
}

extension FormDisplayCollection: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.formDisplayRequestTouchGeuster(enable: true)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.formDisplayRequestTouchGeuster(enable: false)
  }
}
