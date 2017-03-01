//
//  GiveSpeechViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class GiveSpeechViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.isScrollEnabled = false
    }
  }
  @IBOutlet weak var sendSpeechButton: UIBarButtonItem!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: CHTextView! {
    didSet {
      descriptionTextView.layer.cornerRadius  = 5
      descriptionTextView.layer.borderWidth   = 1
      descriptionTextView.layer.borderColor   = UIColor.lightGray.withAlphaComponent(0.3).cgColor
      descriptionTextView.placeholder         = "placeholder"
    }
  }
  @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    keyboardDelegate = self
    setupGestureRecognizer()
  }

  func setupGestureRecognizer() {
    let dissmisKBTouch =
      UITapGestureRecognizer(target: self,
                             action: #selector(GiveSpeechViewController.dismissKeyboard))
    view.addGestureRecognizer(dissmisKBTouch)
  }

  func sendSpeech() {
    // Do stuff here ...
  }

  @IBAction func sendSpeechButtonPressed(_ sender: UIBarButtonItem) {
    sendSpeech()
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }

}

// MARK: - UITextFieldDelegate
extension GiveSpeechViewController {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == titleTextField {
      descriptionTextView.becomeFirstResponder()
      return false
    }
    return true
  }
}

// MARK: - KeyboardHandlerDelegate
extension GiveSpeechViewController: KeyboardHandlerDelegate {
  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {

    switch state {
    case .frameChanged:
      break
    case .opened:
      scrollView.isScrollEnabled = true
      let tabbarHeight = tabBarController?.tabBar.bounds.height ?? 0
      scrollViewBottomConstraint.constant = info.endFrame.height - tabbarHeight
      break
    case .hidden:
      scrollView.isScrollEnabled = false
      scrollViewBottomConstraint.constant = 0
      break
    }
    view.layoutIfNeeded()
  }
}
