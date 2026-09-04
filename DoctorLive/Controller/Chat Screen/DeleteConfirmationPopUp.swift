import UIKit

class DeleteConfirmationPopupVC: UIViewController {

    var deleteAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 235/255, alpha: 1.0)
        iconContainer.layer.cornerRadius = 35
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainer)
        
        let trashIcon = UIImageView()
        trashIcon.image = UIImage(systemName: "trash.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        trashIcon.contentMode = .scaleAspectFit
        trashIcon.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(trashIcon)
        
        let titleLabel = UILabel()
        titleLabel.text = "Confirm Deletion"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "Are you sure you want to delete this item?"
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1.0)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.layer.cornerRadius = 8
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(deleteButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitleColor(UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1.0), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            iconContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            iconContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 70),
            iconContainer.heightAnchor.constraint(equalToConstant: 70),
            
            trashIcon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            trashIcon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            trashIcon.widthAnchor.constraint(equalToConstant: 30),
            trashIcon.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            deleteButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    @objc private func deleteTapped() {
        self.dismiss(animated: true) {
            self.deleteAction?()
        }
    }

    @objc private func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
