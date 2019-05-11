//
//  ViewController.swift
//  UI_Course3
//
//  Created by Александр Тарасов on 10/05/2019.
//  Copyright © 2019 Aleksandr Tarasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = ""
        
        textView.font = UIFont(name: "Optima-Regular", size: 18)
        textView.backgroundColor = view.backgroundColor
        
        textView.layer.cornerRadius = 10
        
        //Отслеживаем появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //Отслеживаем скрытие клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //скрытие клавиатуры по тапу за пределами текст вью
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true) //скрывает клавиатуру, вызванную для любого объекта
        
        //textView.resignFirstResponder() //скрывает клавиатуру, вызванную для конкретного объекта
    }
    
   @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
    if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
        textView.contentInset = UIEdgeInsets(top: 0,
                                             left: 0,
                                             bottom: keyboardFrame.height - bottomConstraint.constant,
                                             right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }


}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) { //Срабатывает при тапе на текствью
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) { //Срабатывает по окончанию работы с текствью, при тапе за пределами области
        textView.backgroundColor = view.backgroundColor
        textView.textColor = .black
    }
    
    //Ограничения на кол-во вводимых символов
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 60
    }
}
