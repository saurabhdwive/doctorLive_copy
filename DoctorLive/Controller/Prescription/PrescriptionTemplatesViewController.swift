//
//  PrescriptionTemplatesViewController.swift
//  DoctorLive
//
//  Created for Prescription Templates Feature.
//

import UIKit
import PromiseKit

// MARK: - DashedBorderButton Helper
class DashedBorderButton: UIButton {
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        borderLayer.strokeColor = UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 0.85).cgColor
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 1.4
        borderLayer.lineDashPattern = [6, 4]
        layer.addSublayer(borderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
}

// MARK: - PrescriptionTemplateCell
class PrescriptionTemplateCell: UITableViewCell {
    static let reuseIdentifier = "PrescriptionTemplateCell"
    
    private let cardView = UIView()
    private let iconBox = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let chipsScrollView = UIScrollView()
    private let chipsStackView = UIStackView()
    private let buttonsStackView = UIStackView()
    private let useNowButton = UIButton(type: .system)
    private let duplicateButton = UIButton(type: .system)
    
    private var buttonsTopConstraint: NSLayoutConstraint!
    private var buttonsHeightConstraint: NSLayoutConstraint!
    private var buttonsBottomConstraint: NSLayoutConstraint!
    private var chipsBottomConstraint: NSLayoutConstraint!
    
    var onUseNow: (() -> Void)?
    var onDuplicate: (() -> Void)?
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Card container
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 14
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 6
        cardView.layer.shadowOpacity = 1
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Icon box
        iconBox.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1.0)
        iconBox.layer.cornerRadius = 10
        iconBox.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(iconBox)
        
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        iconImageView.image = UIImage(systemName: "doc.text", withConfiguration: config)
        iconImageView.tintColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconBox.addSubview(iconImageView)
        
        // Title & subtitle
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(subtitleLabel)
        
        // Action icons (Edit & Delete)
        let iconBtnConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        editButton.setImage(UIImage(systemName: "pencil", withConfiguration: iconBtnConfig) ?? UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        cardView.addSubview(editButton)
        
        deleteButton.setImage(UIImage(systemName: "trash", withConfiguration: iconBtnConfig), for: .normal)
        deleteButton.tintColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1.0)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        cardView.addSubview(deleteButton)
        
        // Chips scroll view & stack view
        chipsScrollView.showsHorizontalScrollIndicator = false
        chipsScrollView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(chipsScrollView)
        
        chipsStackView.axis = .horizontal
        chipsStackView.spacing = 8
        chipsStackView.alignment = .center
        chipsStackView.distribution = .fill
        chipsStackView.translatesAutoresizingMaskIntoConstraints = false
        chipsScrollView.addSubview(chipsStackView)
        
        // Button row
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 12
        buttonsStackView.distribution = .fill
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(buttonsStackView)
        
        // "Use now" button
        useNowButton.setTitle("Use now".localized(), for: .normal)
        useNowButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5, weight: .semibold)
        useNowButton.setTitleColor(UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0), for: .normal)
        useNowButton.backgroundColor = .white
        useNowButton.layer.cornerRadius = 10
        useNowButton.layer.borderWidth = 1.3
        useNowButton.layer.borderColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0).cgColor
        useNowButton.addTarget(self, action: #selector(useNowTapped), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(useNowButton)
        
        // "Duplicate" button is completely hidden as per requirement
        duplicateButton.isHidden = true
        
        buttonsTopConstraint = buttonsStackView.topAnchor.constraint(equalTo: chipsScrollView.bottomAnchor, constant: 12)
        buttonsHeightConstraint = buttonsStackView.heightAnchor.constraint(equalToConstant: 40)
        buttonsBottomConstraint = cardView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 14)
        chipsBottomConstraint = cardView.bottomAnchor.constraint(equalTo: chipsScrollView.bottomAnchor, constant: 14)
        
        // Constraints
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Icon box
            iconBox.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            iconBox.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            iconBox.widthAnchor.constraint(equalToConstant: 38),
            iconBox.heightAnchor.constraint(equalToConstant: 38),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconBox.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBox.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Delete button on the far right
            deleteButton.centerYAnchor.constraint(equalTo: iconBox.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            deleteButton.widthAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Edit button next to delete button
            editButton.centerYAnchor.constraint(equalTo: iconBox.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            editButton.widthAnchor.constraint(equalToConstant: 28),
            editButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Title & subtitle
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconBox.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8),
            
            // Chips row
            chipsScrollView.topAnchor.constraint(equalTo: iconBox.bottomAnchor, constant: 12),
            chipsScrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            chipsScrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            chipsScrollView.heightAnchor.constraint(equalToConstant: 28),
            
            chipsStackView.topAnchor.constraint(equalTo: chipsScrollView.contentLayoutGuide.topAnchor),
            chipsStackView.leadingAnchor.constraint(equalTo: chipsScrollView.contentLayoutGuide.leadingAnchor),
            chipsStackView.trailingAnchor.constraint(equalTo: chipsScrollView.contentLayoutGuide.trailingAnchor),
            chipsStackView.bottomAnchor.constraint(equalTo: chipsScrollView.contentLayoutGuide.bottomAnchor),
            chipsStackView.heightAnchor.constraint(equalTo: chipsScrollView.heightAnchor),
            
            // Buttons row
            buttonsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            buttonsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            buttonsTopConstraint,
            buttonsHeightConstraint,
            buttonsBottomConstraint
        ])
    }
    
    func configure(with template: PrescriptionTemplate, showUseNow: Bool = true) {
        titleLabel.text = template.title
        subtitleLabel.text = "Used \(template.usedCount) times · updated \(template.updatedAt)"
        
        duplicateButton.isHidden = true
        useNowButton.isHidden = !showUseNow
        buttonsStackView.isHidden = !showUseNow
        
        if showUseNow {
            chipsBottomConstraint.isActive = false
            buttonsTopConstraint.constant = 12
            buttonsHeightConstraint.constant = 40
            buttonsTopConstraint.isActive = true
            buttonsHeightConstraint.isActive = true
            buttonsBottomConstraint.isActive = true
        } else {
            buttonsBottomConstraint.isActive = false
            buttonsTopConstraint.isActive = false
            buttonsHeightConstraint.isActive = false
            chipsBottomConstraint.isActive = true
        }
        
        // Rebuild chips
        chipsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Medicines count chip
        let medCount = template.medicines?.count ?? 0
        let medText = medCount == 1 ? "1 medicine" : "\(medCount) medicines"
        chipsStackView.addArrangedSubview(createChip(text: medText))
        
        // Investigations chip
        if let tests = template.investigations, !tests.isEmpty {
            chipsStackView.addArrangedSubview(createChip(text: tests.joined(separator: ", ")))
        } else {
            chipsStackView.addArrangedSubview(createChip(text: "No tests"))
        }
        
        // Follow up chip
        if let days = template.followUpDays, !days.isEmpty {
            chipsStackView.addArrangedSubview(createChip(text: "Follow-up \(days) days"))
        }
        
        // Vitals chip
        let hasVitals = !(template.temperature?.isEmpty ?? true) ||
                        !(template.pulse?.isEmpty ?? true) ||
                        !(template.bloodPressureSystolic?.isEmpty ?? true) ||
                        !(template.bloodSugar?.isEmpty ?? true)
        if hasVitals {
            chipsStackView.addArrangedSubview(createChip(text: "Vitals included"))
        }
    }
    
    private func createChip(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Poppins-Medium", size: 11.5) ?? UIFont.systemFont(ofSize: 11.5, weight: .medium)
        label.textColor = UIColor(red: 51/255, green: 65/255, blue: 85/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return container
    }
    
    @objc private func useNowTapped() {
        onUseNow?()
    }
    
    @objc private func duplicateTapped() {
        onDuplicate?()
    }
    
    @objc private func editTapped() {
        onEdit?()
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}

// MARK: - PrescriptionTemplatesViewController
class PrescriptionTemplatesViewController: UIViewController {
    
    var isSelectMode: Bool = false
    var onSelectTemplate: ((PrescriptionTemplate) -> Void)?
    
    private var templates: [PrescriptionTemplate] = []
    private var service: ApiInterface?
    private let customHeaderView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshControl = UIRefreshControl()
    
    private let cacheKey = "cached_prescription_templates_v1"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        service = DoctorLive.service ?? Network()
        setupCustomHeader()
        setupTableView()
        loadLocalTemplates()
        fetchTemplatesFromApi()
    }
    
    private func setupCustomHeader() {
        // Status bar background view
        let statusBarBg = UIView()
        statusBarBg.backgroundColor = .white
        statusBarBg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusBarBg)
        
        customHeaderView.backgroundColor = .white
        customHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customHeaderView)
        
        // Back button (<)
        let backBtn = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        backBtn.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backBtn.tintColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        customHeaderView.addSubview(backBtn)
        
        // Center Title (My templates)
        let titleLabel = UILabel()
        titleLabel.text = "My templates".localized()
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = UIColor(red: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customHeaderView.addSubview(titleLabel)
        
        // Add Button (+)
        let addBtn = UIButton(type: .system)
        let addConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        addBtn.setImage(UIImage(systemName: "plus", withConfiguration: addConfig), for: .normal)
        addBtn.tintColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1.0)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.addTarget(self, action: #selector(createTemplateTapped), for: .touchUpInside)
        customHeaderView.addSubview(addBtn)
        
        NSLayoutConstraint.activate([
            statusBarBg.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarBg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarBg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarBg.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            customHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customHeaderView.heightAnchor.constraint(equalToConstant: 48),
            
            backBtn.leadingAnchor.constraint(equalTo: customHeaderView.leadingAnchor, constant: 8),
            backBtn.centerYAnchor.constraint(equalTo: customHeaderView.centerYAnchor),
            backBtn.widthAnchor.constraint(equalToConstant: 44),
            backBtn.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: customHeaderView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customHeaderView.centerYAnchor),
            
            addBtn.trailingAnchor.constraint(equalTo: customHeaderView.trailingAnchor, constant: -8),
            addBtn.centerYAnchor.constraint(equalTo: customHeaderView.centerYAnchor),
            addBtn.widthAnchor.constraint(equalToConstant: 44),
            addBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrescriptionTemplateCell.self, forCellReuseIdentifier: PrescriptionTemplateCell.reuseIdentifier)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupTableHeader()
        setupTableFooter()
    }
    
    private func setupTableHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 70))
        header.backgroundColor = .clear
        
        let subtitle = UILabel()
        subtitle.text = "Save a prescription you write often. Applying a template fills the form, and you can edit everything before sending.".localized()
        subtitle.font = UIFont(name: "Poppins-Regular", size: 13.5) ?? UIFont.systemFont(ofSize: 13.5)
        subtitle.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        subtitle.numberOfLines = 0
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(subtitle)
        
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: header.topAnchor, constant: 14),
            subtitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            subtitle.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            subtitle.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12)
        ])
        
        header.layoutIfNeeded()
        let size = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height))
        header.frame.size.height = size.height
        tableView.tableHeaderView = header
    }
    
    private func setupTableFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 170))
        footer.backgroundColor = .clear
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(stack)
        
        // Dashed Create Template Button
        let createBtn = DashedBorderButton(type: .system)
        createBtn.setTitle("+  Create a template".localized(), for: .normal)
        createBtn.setTitleColor(UIColor(red: 29/255, green: 78/255, blue: 216/255, alpha: 1.0), for: .normal)
        createBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14.5) ?? UIFont.systemFont(ofSize: 14.5, weight: .semibold)
        createBtn.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        createBtn.layer.cornerRadius = 12
        createBtn.clipsToBounds = true
        createBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        createBtn.addTarget(self, action: #selector(createTemplateTapped), for: .touchUpInside)
        stack.addArrangedSubview(createBtn)
        
        // Tip Card
        let tipCard = UIView()
        tipCard.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0)
        tipCard.layer.cornerRadius = 12
        tipCard.layer.borderWidth = 1
        tipCard.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        tipCard.translatesAutoresizingMaskIntoConstraints = false
        
        let tipLabel = UILabel()
        tipLabel.text = "You can also save any prescription you are writing as a template from the form's menu.".localized()
        tipLabel.font = UIFont(name: "Poppins-Regular", size: 12.5) ?? UIFont.systemFont(ofSize: 12.5)
        tipLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        tipLabel.numberOfLines = 0
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipCard.addSubview(tipLabel)
        
        NSLayoutConstraint.activate([
            tipLabel.topAnchor.constraint(equalTo: tipCard.topAnchor, constant: 14),
            tipLabel.leadingAnchor.constraint(equalTo: tipCard.leadingAnchor, constant: 14),
            tipLabel.trailingAnchor.constraint(equalTo: tipCard.trailingAnchor, constant: -14),
            tipLabel.bottomAnchor.constraint(equalTo: tipCard.bottomAnchor, constant: -14)
        ])
        
        stack.addArrangedSubview(tipCard)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: footer.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -24)
        ])
        
        footer.layoutIfNeeded()
        let size = footer.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height))
        footer.frame.size.height = size.height
        tableView.tableFooterView = footer
    }
    
    // MARK: - Local Data & Fallback Cache
    private func loadLocalTemplates() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let cached = try? JSONDecoder().decode([PrescriptionTemplate].self, from: data) {
            // Filter out old dummy templates
            let real = cached.filter {
                $0.id != "1" && $0.id != "2" && $0.id != "3" &&
                $0.title != "Acute tonsillitis — adult" &&
                $0.title != "URTI — paediatric" &&
                $0.title != "Gastritis — standard"
            }
            self.templates = real
            self.saveTemplatesToCache(real)
            self.tableView.reloadData()
        } else {
            self.templates = []
            self.tableView.reloadData()
        }
    }
    
    private func saveTemplatesToCache(_ list: [PrescriptionTemplate]) {
        let clean = list.filter {
            $0.id != "1" && $0.id != "2" && $0.id != "3" &&
            $0.title != "Acute tonsillitis — adult" &&
            $0.title != "URTI — paediatric" &&
            $0.title != "Gastritis — standard"
        }
        if let encoded = try? JSONEncoder().encode(clean) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    // MARK: - API Calls
    private func fetchTemplatesFromApi() {
        let token = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
        let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
        guard !token.isEmpty else {
            refreshControl.endRefreshing()
            print("Prescription templates: No token found in UserDefaults")
            return
        }
        
        let param: [String: Any] = [
            "token": token,
            "language_type": code
        ]
        
        firstly {
            service!.prescriptionTemplateList(parameters: param, header: "DeviceToken")
        }.done { [weak self] (resp: PrescriptionTemplateListResponse) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            if let list = resp.data {
                self.templates = list
                self.saveTemplatesToCache(list)
                self.tableView.reloadData()
            }
        }.catch { [weak self] error in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            print("Prescription templates API error: \(error.localizedDescription)")
        }
    }
    
    @objc private func handleRefresh() {
        fetchTemplatesFromApi()
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func createTemplateTapped() {
        let vc = CreateEditTemplateViewController()
        vc.onSave = { [weak self] newTemplate in
            guard let self = self else { return }
            self.templates.insert(newTemplate, at: 0)
            self.saveTemplatesToCache(self.templates)
            self.tableView.reloadData()
            AppToast.showMessage(message: "Template created successfully".localized())
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func useTemplate(_ template: PrescriptionTemplate, index: Int) {
        // Increment usage count locally
        var updated = template
        updated.usedCount += 1
        updated.updatedAt = "Today"
        templates[index] = updated
        saveTemplatesToCache(templates)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        
        if isSelectMode || onSelectTemplate != nil {
            onSelectTemplate?(updated)
            backTapped()
        } else {
            // Opened from menu -> launch prescription form with this template
            let vc = PrescriptionViewController()
            vc.initialTemplate = updated
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func duplicateTemplate(_ template: PrescriptionTemplate, index: Int) {
        let newTitle = "\(template.title) (Copy)"
        let newId = UUID().uuidString
        let duplicated = PrescriptionTemplate(
            id: newId,
            title: newTitle,
            usedCount: 0,
            updatedAt: "Just now",
            chiefComplain: template.chiefComplain,
            pastHistory: template.pastHistory,
            provisionalDiagnosis: template.provisionalDiagnosis,
            generalAdvice: template.generalAdvice,
            general: template.general,
            temperature: template.temperature,
            bloodPressureSystolic: template.bloodPressureSystolic,
            bloodPressureDiastolic: template.bloodPressureDiastolic,
            pulse: template.pulse,
            bloodSugar: template.bloodSugar,
            investigations: template.investigations,
            followUpDays: template.followUpDays,
            medicines: template.medicines
        )
        
        templates.insert(duplicated, at: index + 1)
        saveTemplatesToCache(templates)
        tableView.reloadData()
        AppToast.showMessage(message: "Template duplicated".localized())
        
        // Call API
        let token = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
        let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
        let dupParams: [String: Any] = [
            "token": token,
            "language_type": code,
            "template_id": template.id
        ]
        firstly {
            service!.duplicatePrescriptionTemplate(parameters: dupParams, header: "DeviceToken")
        }.done { (resp: PrescriptionTemplateCommonResponse) in
            print("Template duplicated on server: \(resp)")
        }.catch { error in
            print("Template duplicate API fallback: \(error.localizedDescription)")
        }
    }
    
    private func editTemplate(_ template: PrescriptionTemplate, index: Int) {
        let vc = CreateEditTemplateViewController()
        vc.existingTemplate = template
        vc.onSave = { [weak self] updatedTemplate in
            guard let self = self else { return }
            self.templates[index] = updatedTemplate
            self.saveTemplatesToCache(self.templates)
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            AppToast.showMessage(message: "Template updated successfully".localized())
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func deleteTemplate(_ template: PrescriptionTemplate, index: Int) {
        let alert = UIAlertController(
            title: "Delete Template".localized(),
            message: "Are you sure you want to delete \"\(template.title)\"?".localized(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.templates.remove(at: index)
            self.saveTemplatesToCache(self.templates)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            AppToast.showMessage(message: "Template deleted".localized())
            
            // Call API
            let token = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
            let code = UserDefaults.standard.string(forKey: Constants.languageCode) ?? "en"
            let delParams: [String: Any] = [
                "token": token,
                "language_type": code,
                "template_id": template.id
            ]
            firstly {
                self.service!.deletePrescriptionTemplate(parameters: delParams, header: "DeviceToken")
            }.done { (resp: PrescriptionTemplateCommonResponse) in
                print("Template deleted on server: \(resp)")
            }.catch { error in
                print("Template delete API fallback: \(error.localizedDescription)")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PrescriptionTemplatesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrescriptionTemplateCell.reuseIdentifier, for: indexPath) as? PrescriptionTemplateCell else {
            return UITableViewCell()
        }
        
        let template = templates[indexPath.row]
        cell.configure(with: template, showUseNow: isSelectMode)
        
        cell.onUseNow = { [weak self] in
            self?.useTemplate(template, index: indexPath.row)
        }
        cell.onDuplicate = { [weak self] in
            self?.duplicateTemplate(template, index: indexPath.row)
        }
        cell.onEdit = { [weak self] in
            self?.editTemplate(template, index: indexPath.row)
        }
        cell.onDelete = { [weak self] in
            self?.deleteTemplate(template, index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let template = templates[indexPath.row]
        if isSelectMode {
            useTemplate(template, index: indexPath.row)
        } else {
            editTemplate(template, index: indexPath.row)
        }
    }
}
