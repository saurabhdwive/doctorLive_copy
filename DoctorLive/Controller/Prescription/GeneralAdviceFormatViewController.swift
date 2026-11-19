//
//  GeneralAdviceFormatViewController.swift
//  DoctorLive
//
//  Created for Prescription UI Redesign.
//

import UIKit

class GeneralAdviceFormatViewController: UIViewController, UITextViewDelegate {

    var initialText: String = ""
    var onSave: ((String) -> Void)?
    
    // UI Elements
    private let navBarView = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .custom)
    private let doneButton = UIButton(type: .system)
    
    private let toolbarScrollView = UIScrollView()
    private let toolbarStackView = UIStackView()
    
    private let boldBtn = UIButton(type: .custom)
    private let italicBtn = UIButton(type: .custom)
    private let underlineBtn = UIButton(type: .custom)
    private let bulletListBtn = UIButton(type: .custom)
    private let numberListBtn = UIButton(type: .custom)
    private let headingBtn = UIButton(type: .custom)
    private let snippetsBtn = UIButton(type: .system)
    
    private let textView = UITextView()
    private let footerContainer = UIView()
    private let footerLabel = UILabel()
    
    private var isBoldActive = false
    private var isItalicActive = false
    private var isUnderlineActive = false
    private var isHeadingActive = false
    private var isNumberedActive = false
    private var isBulletActive = false
    
    private var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialText()
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // 1. Navigation Bar
        navBarView.backgroundColor = .white
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBarView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        if let backImg = UIImage(systemName: "chevron.left") {
            backButton.setImage(backImg, for: .normal)
            backButton.tintColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        } else if let backImg = UIImage(named: "back1") {
            backButton.setImage(backImg, for: .normal)
        } else {
            backButton.setTitle("‹", for: .normal)
            backButton.setTitleColor(UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0), for: .normal)
            backButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navBarView.addSubview(backButton)
        
        titleLabel.text = "General Advice".localized()
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navBarView.addSubview(titleLabel)
        
        doneButton.setTitle("Done".localized(), for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0) // #1976D2
        doneButton.layer.cornerRadius = 8
        doneButton.clipsToBounds = true
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        navBarView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarView.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor, constant: 14),
            backButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: navBarView.trailingAnchor, constant: -14),
            doneButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 68),
            doneButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // 2. Toolbar
        let toolbarContainer = UIView()
        toolbarContainer.backgroundColor = .white
        toolbarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarContainer)
        
        let toolbarBorder = UIView()
        toolbarBorder.backgroundColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0) // #E2E8F0
        toolbarBorder.translatesAutoresizingMaskIntoConstraints = false
        toolbarContainer.addSubview(toolbarBorder)
        
        toolbarScrollView.showsHorizontalScrollIndicator = false
        toolbarScrollView.translatesAutoresizingMaskIntoConstraints = false
        toolbarContainer.addSubview(toolbarScrollView)
        
        toolbarStackView.axis = .horizontal
        toolbarStackView.spacing = 8
        toolbarStackView.alignment = .center
        toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        toolbarScrollView.addSubview(toolbarStackView)
        
        // Setup Toolbar Buttons
        setupToolbarButton(boldBtn, title: "B", isBoldText: true, action: #selector(boldTapped))
        setupToolbarButton(italicBtn, title: "I", isItalicText: true, action: #selector(italicTapped))
        setupUnderlineButton(underlineBtn, action: #selector(underlineTapped))
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        toolbarStackView.addArrangedSubview(divider)
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        setupIconButton(bulletListBtn, systemName: "list.bullet", fallbackText: "•≡", action: #selector(bulletListTapped))
        setupIconButton(numberListBtn, systemName: "list.number", fallbackText: "1:=", action: #selector(numberListTapped))
        setupToolbarButton(headingBtn, title: "H", isBoldText: true, action: #selector(headingTapped))
        
        // Snippets Button
        snippetsBtn.setTitle("Snippets".localized(), for: .normal)
        snippetsBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        snippetsBtn.setTitleColor(UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0), for: .normal)
        snippetsBtn.backgroundColor = .white
        snippetsBtn.layer.cornerRadius = 8
        snippetsBtn.layer.borderWidth = 1
        snippetsBtn.layer.borderColor = UIColor(red: 203/255, green: 213/255, blue: 225/255, alpha: 1.0).cgColor
        snippetsBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        snippetsBtn.translatesAutoresizingMaskIntoConstraints = false
        snippetsBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        snippetsBtn.addTarget(self, action: #selector(snippetsTapped), for: .touchUpInside)
        toolbarStackView.addArrangedSubview(snippetsBtn)
        
        NSLayoutConstraint.activate([
            toolbarContainer.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            toolbarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarContainer.heightAnchor.constraint(equalToConstant: 52),
            
            toolbarBorder.leadingAnchor.constraint(equalTo: toolbarContainer.leadingAnchor),
            toolbarBorder.trailingAnchor.constraint(equalTo: toolbarContainer.trailingAnchor),
            toolbarBorder.bottomAnchor.constraint(equalTo: toolbarContainer.bottomAnchor),
            toolbarBorder.heightAnchor.constraint(equalToConstant: 1),
            
            toolbarScrollView.topAnchor.constraint(equalTo: toolbarContainer.topAnchor),
            toolbarScrollView.bottomAnchor.constraint(equalTo: toolbarBorder.topAnchor),
            toolbarScrollView.leadingAnchor.constraint(equalTo: toolbarContainer.leadingAnchor, constant: 14),
            toolbarScrollView.trailingAnchor.constraint(equalTo: toolbarContainer.trailingAnchor, constant: -14),
            
            toolbarStackView.topAnchor.constraint(equalTo: toolbarScrollView.topAnchor),
            toolbarStackView.bottomAnchor.constraint(equalTo: toolbarScrollView.bottomAnchor),
            toolbarStackView.leadingAnchor.constraint(equalTo: toolbarScrollView.leadingAnchor),
            toolbarStackView.trailingAnchor.constraint(equalTo: toolbarScrollView.trailingAnchor),
            toolbarStackView.heightAnchor.constraint(equalTo: toolbarScrollView.heightAnchor)
        ])
        
        // 3. Footer Container
        footerContainer.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1.0) // #F8FAFC
        footerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerContainer)
        
        let footerBorder = UIView()
        footerBorder.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        footerBorder.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(footerBorder)
        
        footerLabel.text = "Bold, italic, headings and lists carry through to the printed prescription"
        footerLabel.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        footerLabel.textColor = UIColor(red: 100/255, green: 116/255, blue: 139/255, alpha: 1.0)
        footerLabel.numberOfLines = 0
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(footerLabel)
        
        let bottom = footerContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint = bottom
        
        NSLayoutConstraint.activate([
            bottom,
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            footerBorder.topAnchor.constraint(equalTo: footerContainer.topAnchor),
            footerBorder.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            footerBorder.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor),
            footerBorder.heightAnchor.constraint(equalToConstant: 1),
            
            footerLabel.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 10),
            footerLabel.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: -10),
            footerLabel.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor, constant: 16),
            footerLabel.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor, constant: -16)
        ])
        
        // 4. Main Rich Text Area
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: toolbarContainer.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: footerContainer.topAnchor)
        ])
    }
    
    private func setupToolbarButton(_ button: UIButton, title: String, isBoldText: Bool = false, isItalicText: Bool = false, action: Selector) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let font: UIFont
        if isBoldText {
            font = UIFont.boldSystemFont(ofSize: 15)
        } else if isItalicText {
            font = UIFont.italicSystemFont(ofSize: 15)
        } else {
            font = UIFont.systemFont(ofSize: 15)
        }
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = font
        button.addTarget(self, action: action, for: .touchUpInside)
        toolbarStackView.addArrangedSubview(button)
    }
    
    private func setupUnderlineButton(_ button: UIButton, action: Selector) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let attrTitle = NSAttributedString(string: "U", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        button.setAttributedTitle(attrTitle, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        toolbarStackView.addArrangedSubview(button)
    }
    
    private func setupIconButton(_ button: UIButton, systemName: String, fallbackText: String, action: Selector) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        if let img = UIImage(systemName: systemName) {
            button.setImage(img, for: .normal)
            button.tintColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        } else {
            button.setTitle(fallbackText, for: .normal)
            button.setTitleColor(UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        toolbarStackView.addArrangedSubview(button)
    }
    
    private func updateButtonHighlight(_ button: UIButton, isActive: Bool) {
        if isActive {
            button.backgroundColor = UIColor(red: 240/255, green: 247/255, blue: 255/255, alpha: 1.0)
            button.layer.borderColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0).cgColor
            button.layer.borderWidth = 1.5
            button.tintColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0)
            button.setTitleColor(UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1.0), for: .normal)
        } else {
            button.backgroundColor = .white
            button.layer.borderColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1.0).cgColor
            button.layer.borderWidth = 1
            button.tintColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
            button.setTitleColor(UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0), for: .normal)
        }
    }
    
    // MARK: - Initial Text Parsing
    private func loadInitialText() {
        if initialText.isEmpty {
            // Pre-fill with the default advice shown in the screenshot for seamless convenience
            let defaultAdvice = """
            ঘরোয়া যত্ন
            1. পর্যাপ্ত বিশ্রাম নিন।
            2. কুসুম গরম পানি দিয়ে গার্গল করুন।
            3. প্রচুর পানি ও তরল খাবার খান।

            কখন যোগাযোগ করবেন
            • জ্বর ১০৩°F এর বেশি হলে
            • শ্বাস নিতে কষ্ট হলে
            """
            renderFormattedText(defaultAdvice)
            updateButtonHighlight(numberListBtn, isActive: true)
        } else {
            renderFormattedText(initialText)
        }
    }
    
    private func renderFormattedText(_ raw: String) {
        let attr = NSMutableAttributedString()
        let lines = raw.components(separatedBy: "\n")
        
        for (i, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty {
                attr.append(NSAttributedString(string: line, attributes: [
                    .font: UIFont.systemFont(ofSize: 15),
                    .foregroundColor: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
                ]))
                if i < lines.count - 1 {
                    attr.append(NSAttributedString(string: "\n"))
                }
                continue
            }
            
            let isNumber = trimmed.first?.isNumber ?? false
            let isBullet = trimmed.starts(with: "•") || trimmed.starts(with: "-")
            let isHeading = trimmed.contains("ঘরোয়া যত্ন") || trimmed.contains("যোগাযোগ করবেন") || trimmed.hasSuffix(":") || (!isBullet && !isNumber && trimmed.count < 30)
            
            let paragraph = NSMutableAttributedString()
            
            if isHeading {
                let headingFont = UIFont.boldSystemFont(ofSize: 16.5)
                let headingColor = UIColor(red: 15/255, green: 41/255, blue: 66/255, alpha: 1.0)
                let itemAttr = NSAttributedString(string: line, attributes: [
                    .font: headingFont,
                    .foregroundColor: headingColor
                ])
                paragraph.append(itemAttr)
            } else {
                let normalFont = UIFont.systemFont(ofSize: 15)
                let normalColor = UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
                
                // Parse markdown-like bold (**text**) or italic (*text*) if present
                let itemAttr = parseInlineFormatting(line, baseFont: normalFont, baseColor: normalColor)
                paragraph.append(itemAttr)
            }
            
            attr.append(paragraph)
            if i < lines.count - 1 {
                attr.append(NSAttributedString(string: "\n"))
            }
        }
        
        textView.attributedText = attr
    }
    
    private func parseInlineFormatting(_ text: String, baseFont: UIFont, baseColor: UIColor) -> NSAttributedString {
        let result = NSMutableAttributedString(string: text, attributes: [.font: baseFont, .foregroundColor: baseColor])
        
        // Highlight words like 'বিশ্রাম' if in sample, or check for markdown bold **...**
        let boldWords = ["বিশ্রাম"]
        for word in boldWords {
            let nsStr = text as NSString
            var searchRange = NSRange(location: 0, length: nsStr.length)
            while true {
                let foundRange = nsStr.range(of: word, options: [], range: searchRange)
                if foundRange.location == NSNotFound { break }
                result.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: baseFont.pointSize), range: foundRange)
                let newLocation = foundRange.location + foundRange.length
                if newLocation >= nsStr.length { break }
                searchRange = NSRange(location: newLocation, length: nsStr.length - newLocation)
            }
        }
        
        let italicWords = ["গার্গল করুন"]
        for word in italicWords {
            let nsStr = text as NSString
            var searchRange = NSRange(location: 0, length: nsStr.length)
            while true {
                let foundRange = nsStr.range(of: word, options: [], range: searchRange)
                if foundRange.location == NSNotFound { break }
                result.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: baseFont.pointSize), range: foundRange)
                let newLocation = foundRange.location + foundRange.length
                if newLocation >= nsStr.length { break }
                searchRange = NSRange(location: newLocation, length: nsStr.length - newLocation)
            }
        }
        
        return result
    }
    
    // MARK: - Toolbar Actions
    @objc private func boldTapped() {
        isBoldActive.toggle()
        updateButtonHighlight(boldBtn, isActive: isBoldActive)
        applyFontTrait(.traitBold, isActive: isBoldActive)
    }
    
    @objc private func italicTapped() {
        isItalicActive.toggle()
        updateButtonHighlight(italicBtn, isActive: isItalicActive)
        applyFontTrait(.traitItalic, isActive: isItalicActive)
    }
    
    @objc private func underlineTapped() {
        isUnderlineActive.toggle()
        updateButtonHighlight(underlineBtn, isActive: isUnderlineActive)
        
        let range = textView.selectedRange
        let val = isUnderlineActive ? NSUnderlineStyle.single.rawValue : 0
        if range.length > 0 {
            let attr = NSMutableAttributedString(attributedString: textView.attributedText)
            attr.addAttribute(.underlineStyle, value: val, range: range)
            textView.attributedText = attr
            textView.selectedRange = range
        } else {
            var typ = textView.typingAttributes
            typ[.underlineStyle] = val
            textView.typingAttributes = typ
        }
    }
    
    private func applyFontTrait(_ trait: UIFontDescriptor.SymbolicTraits, isActive: Bool) {
        let range = textView.selectedRange
        if range.length > 0 {
            let attr = NSMutableAttributedString(attributedString: textView.attributedText)
            attr.enumerateAttribute(.font, in: range, options: []) { (value, subRange, _) in
                let currentFont = (value as? UIFont) ?? UIFont.systemFont(ofSize: 15)
                var traits = currentFont.fontDescriptor.symbolicTraits
                if isActive {
                    traits.insert(trait)
                } else {
                    traits.remove(trait)
                }
                if let desc = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                    let newFont = UIFont(descriptor: desc, size: currentFont.pointSize)
                    attr.addAttribute(.font, value: newFont, range: subRange)
                }
            }
            textView.attributedText = attr
            textView.selectedRange = range
        } else {
            var typ = textView.typingAttributes
            let currentFont = (typ[.font] as? UIFont) ?? UIFont.systemFont(ofSize: 15)
            var traits = currentFont.fontDescriptor.symbolicTraits
            if isActive {
                traits.insert(trait)
            } else {
                traits.remove(trait)
            }
            if let desc = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                typ[.font] = UIFont(descriptor: desc, size: currentFont.pointSize)
                textView.typingAttributes = typ
            }
        }
    }
    
    @objc private func bulletListTapped() {
        isBulletActive.toggle()
        isNumberedActive = false
        updateButtonHighlight(bulletListBtn, isActive: isBulletActive)
        updateButtonHighlight(numberListBtn, isActive: false)
        toggleListPrefix(bullet: true)
    }
    
    @objc private func numberListTapped() {
        isNumberedActive.toggle()
        isBulletActive = false
        updateButtonHighlight(numberListBtn, isActive: isNumberedActive)
        updateButtonHighlight(bulletListBtn, isActive: false)
        toggleListPrefix(bullet: false)
    }
    
    private func toggleListPrefix(bullet: Bool) {
        let text = textView.text ?? ""
        let selected = textView.selectedRange
        let nsText = text as NSString
        let lineRange = nsText.lineRange(for: selected)
        let selectedParagraph = nsText.substring(with: lineRange)
        let lines = selectedParagraph.components(separatedBy: "\n")
        
        var newLines: [String] = []
        var numberCounter = 1
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty {
                newLines.append(line)
                continue
            }
            
            // Strip any existing prefix
            var cleanLine = trimmed
            if cleanLine.starts(with: "• ") {
                cleanLine = String(cleanLine.dropFirst(2))
            } else if let regex = try? NSRegularExpression(pattern: "^[0-9]+[.)]\\s*"),
                      let match = regex.firstMatch(in: cleanLine, range: NSRange(location: 0, length: cleanLine.utf16.count)) {
                cleanLine = (cleanLine as NSString).substring(from: match.range.location + match.range.length)
            }
            
            if bullet {
                if isBulletActive {
                    newLines.append("• " + cleanLine)
                } else {
                    newLines.append(cleanLine)
                }
            } else {
                if isNumberedActive {
                    newLines.append("\(numberCounter). " + cleanLine)
                    numberCounter += 1
                } else {
                    newLines.append(cleanLine)
                }
            }
        }
        
        let replacement = newLines.joined(separator: "\n")
        let mutableAttr = NSMutableAttributedString(attributedString: textView.attributedText)
        let replacementAttr = NSAttributedString(string: replacement, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        ])
        mutableAttr.replaceCharacters(in: lineRange, with: replacementAttr)
        textView.attributedText = mutableAttr
    }
    
    @objc private func headingTapped() {
        isHeadingActive.toggle()
        updateButtonHighlight(headingBtn, isActive: isHeadingActive)
        
        let text = textView.text ?? ""
        let selected = textView.selectedRange
        let nsText = text as NSString
        let lineRange = nsText.lineRange(for: selected)
        
        let attr = NSMutableAttributedString(attributedString: textView.attributedText)
        let targetFont: UIFont = isHeadingActive ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 15)
        let targetColor: UIColor = isHeadingActive ? UIColor(red: 15/255, green: 41/255, blue: 66/255, alpha: 1.0) : UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        
        attr.addAttribute(.font, value: targetFont, range: lineRange)
        attr.addAttribute(.foregroundColor, value: targetColor, range: lineRange)
        textView.attributedText = attr
        textView.selectedRange = selected
    }
    
    @objc private func snippetsTapped() {
        let alert = UIAlertController(title: "Advice Snippets".localized(), message: "Choose medical advice to insert".localized(), preferredStyle: .actionSheet)
        
        let homeCare = """
        ঘরোয়া যত্ন
        1. পর্যাপ্ত বিশ্রাম নিন।
        2. কুসুম গরম পানি দিয়ে গার্গল করুন।
        3. প্রচুর পানি ও তরল খাবার খান।
        """
        
        let warningSigns = """
        কখন যোগাযোগ করবেন
        • জ্বর ১০৩°F এর বেশি হলে
        • শ্বাস নিতে কষ্ট হলে
        • তীব্র গলা ব্যথা বা গিলতে সমস্যা হলে
        """
        
        let diet = """
        খাদ্যাভ্যাস ও সতর্কতা
        • ঠান্ডা পানি, আইসক্রিম ও তৈলাক্ত খাবার পরিহার করুন।
        • টাটকা পুষ্টিকর নরম খাবার গ্রহণ করুন।
        """
        
        let fullTemplate = """
        ঘরোয়া যত্ন
        1. পর্যাপ্ত বিশ্রাম নিন।
        2. কুসুম গরম পানি দিয়ে গার্গল করুন।
        3. প্রচুর পানি ও তরল খাবার খান।

        কখন যোগাযোগ করবেন
        • জ্বর ১০৩°F এর বেশি হলে
        • শ্বাস নিতে কষ্ট হলে
        """
        
        alert.addAction(UIAlertAction(title: "ঘরোয়া যত্ন (Home Care)", style: .default, handler: { [weak self] _ in
            self?.insertSnippet(homeCare)
        }))
        alert.addAction(UIAlertAction(title: "কখন যোগাযোগ করবেন (Warning Signs)", style: .default, handler: { [weak self] _ in
            self?.insertSnippet(warningSigns)
        }))
        alert.addAction(UIAlertAction(title: "খাদ্যাভ্যাস ও সতর্কতা (Diet & Precautions)", style: .default, handler: { [weak self] _ in
            self?.insertSnippet(diet)
        }))
        alert.addAction(UIAlertAction(title: "Complete Advice Template", style: .default, handler: { [weak self] _ in
            self?.renderFormattedText(fullTemplate)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = snippetsBtn
            popover.sourceRect = snippetsBtn.bounds
        }
        present(alert, animated: true)
    }
    
    private func insertSnippet(_ snippet: String) {
        let currentText = textView.text ?? ""
        if currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            renderFormattedText(snippet)
        } else {
            let combined = currentText + "\n\n" + snippet
            renderFormattedText(combined)
        }
    }
    
    // MARK: - Navigation Actions
    @objc private func backButtonTapped() {
        if let nav = navigationController, nav.viewControllers.contains(self) {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func doneButtonTapped() {
        let plainText = textView.text ?? ""
        onSave?(plainText)
        if let nav = navigationController, nav.viewControllers.contains(self) {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        bottomConstraint?.constant = -max(0, keyboardHeight)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
