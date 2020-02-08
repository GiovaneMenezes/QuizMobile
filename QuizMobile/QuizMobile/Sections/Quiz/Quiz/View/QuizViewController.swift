//
//  QuizViewController.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 07/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var bottonViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var viewModel: QuizViewModel?
    
    init(viewModel: QuizViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpTableView()
        listenObservables()
        keyboardListener()
        viewModel?.fetchQustion()
        wordTextField.addTarget(nil, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func keyboardListener() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func setUpTableView() {
        tableView.register(QuizViewCell.self)
    }
    
    func listenObservables() {
        viewModel?.questionObservable.didChange = { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .loading:
                print("show loading")
            case .loaded:
                self.pointsLabel.text = self.viewModel?.score
                self.titleLabel.text = self.viewModel?.title
            case .error(let error):
                print("Error: \(error)")
            default:
                break
            }
        }
        
        viewModel?.answersObservable.didChange = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.wordTextField.text = ""
        }
    }
    
    @objc func textDidChange() {
        if let string = wordTextField.text {
            viewModel?.answerTextDidUpdate(string: string)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            bottonViewBottonConstraint.constant = keyboardHeight
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottonViewBottonConstraint.constant = 0
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension QuizViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfHits ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(of: QuizViewCell.self, for: indexPath) { cell in
            cell.fill(title: self.viewModel?.answers[indexPath.row] ?? "")
        }
    }
}
