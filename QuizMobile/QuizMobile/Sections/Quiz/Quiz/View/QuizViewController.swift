//
//  QuizViewController.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 07/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import UIKit

class QuizViewController: BaseViewController {
    
    @IBOutlet weak var bottonViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var bottomBarStackView: UIStackView!
    
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
        setUpTableView()
        listenObservables()
        keyboardListener()
        viewModel?.fetchQustion()
        wordTextField.addTarget(nil, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            bottomBarStackView.axis = .horizontal
            timeLabel.textAlignment = .center
            pointsLabel.textAlignment = .center
        } else {
            bottomBarStackView.axis = .vertical
            timeLabel.textAlignment = .right
            pointsLabel.textAlignment = .left
        }
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
                self.displayLoading(show: true)
                self.cleanLabels()
            case .loaded:
                self.displayLoading(show: false)
                self.pointsLabel.text = self.viewModel?.score
                self.titleLabel.text = self.viewModel?.title
            case .error(let error):
                self.displayLoading(show: false)
                let errorMessage: String = (error as? RequestError)?.localizedDescription ?? error.localizedDescription
                self.displayTryAgainAlert(title: "Error",
                                          message: "\(errorMessage)",
                                          buttonTitle: "Try Again")
            default:
                break
            }
        }
        
        viewModel?.answersObservable.didChange = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.wordTextField.text = ""
            self.pointsLabel.text = self.viewModel?.score
        }
        
        viewModel?.playObservable.didChange = { [weak self] isPlaying in
            guard let self = self else { return }
            self.wordTextField.isUserInteractionEnabled = isPlaying
            self.actionButton.setTitle(isPlaying ? "Reset" : "Start", for: .normal)
            if !isPlaying {
                self.wordTextField.resignFirstResponder()
            } else {
                self.wordTextField.becomeFirstResponder()
            }
        }
        
        viewModel?.timerObservable.didChange = { [weak self] state in
            guard let self = self, let viewModel = self.viewModel else { return }
            self.timeLabel.text = state.label
            switch state {
            case .finished:
                self.displayTryAgainAlert(title: "Time finished",
                                          message: viewModel.timeUpMessage(),
                                          buttonTitle: "Try Again")
            default:
                break
            }
        }
        
        viewModel?.winObservable.didChange = { [weak self] _ in
            guard let self = self else { return }
            self.displayTryAgainAlert(title: "Congratulations",
                                      message: "Good job! You found all the answers on time. Keep up with the great work.",
                                      buttonTitle: "Play Again")
        }
    }
    
    func cleanLabels() {
        titleLabel.text = "-"
        pointsLabel.text = "-"
        timeLabel.text = "-"
    }
    
    func displayTryAgainAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { [weak self] _ in
            self?.viewModel?.getNewQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonDidTap(_ sender: Any) {
        viewModel?.actionButtonDidTap()
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
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            bottonViewBottonConstraint.constant = keyboardHeight - bottomPadding
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
