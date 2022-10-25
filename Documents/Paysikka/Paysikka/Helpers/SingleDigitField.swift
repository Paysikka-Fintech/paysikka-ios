//
//  Constants.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import UIKit

class SingleDigitField: UITextField {
    var pressedDelete = false
    override func willMove(toSuperview newSuperview: UIView?) {
        keyboardType = .numberPad
        textAlignment = .center
        isSecureTextEntry = true
        isUserInteractionEnabled = true
    }
//    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
    override func deleteBackward() {
        pressedDelete = true
        sendActions(for: .editingChanged)
    }
}

