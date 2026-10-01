 

import Foundation
import UIKit
// MARK: - Consultation Detail View Controller

final class ConsultationDetailViewController:
    UIViewController {

    private let consultation: Consultation

    init(consultation: Consultation) {

        self.consultation = consultation

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = Theme.card

        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let targetSize = CGSize(
            width: view.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )

        let height = view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        preferredContentSize = CGSize(
            width: view.bounds.width,
            height: height
        )
    }

    private func setupUI() {

        let scrollView = UIScrollView()

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])

        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 20

        scrollView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stack.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: 28
            ),

            stack.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                constant: 18
            ),

            stack.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor,
                constant: -18
            ),

            stack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -26
            )
        ])

        let title = UILabel()

        title.text = consultation.patient

        title.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )

        title.textColor = Theme.ink
        title.numberOfLines = 0

        stack.addArrangedSubview(title)

        let booking = UILabel()

        booking.text =
            "Booking #\(consultation.booking) · \(consultation.date)"

        booking.font = .systemFont(
            ofSize: 14
        )

        booking.textColor = Theme.ink3

        booking.numberOfLines = 0

        booking.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(booking)

        stack.setCustomSpacing(
            8,
            after: booking
        )

        stack.addArrangedSubview(
            createBadge()
        )

        stack.setCustomSpacing(
            14,
            after: createBadge()
        )

        let breakdown =
            createBreakdown()

        stack.addArrangedSubview(
            breakdown
        )

        if let note = consultation.note {

            stack.addArrangedSubview(
                createInfoBox(
                    text: note,
                    background: Theme.line2,
                    textColor: Theme.ink2
                )
            )
        }

        if consultation.status == .paid,
           let payoutID = consultation.payoutId {

            let text =
                "Paid out under payout \(payoutID). Open Payout History to see the rest of that payment."

            stack.addArrangedSubview(
                createInfoBox(
                    text: text,
                    background: Theme.line2,
                    textColor: Theme.ink2
                )
            )
        }

        if consultation.status == .voided {

            var text =
                "Reversed on \(consultation.voidedDate ?? ""). "

            text += consultation.voidReason ?? ""

            if consultation.clawback {

                text +=
                    " This amount had already been paid out (under \(consultation.payoutId ?? "")), so it's flagged to be deducted from your next payout rather than pulled back directly."
            }

            stack.addArrangedSubview(
                createInfoBox(
                    text: text,
                    background: Theme.dangerBg,
                    textColor: Theme.danger
                )
            )
        }

        let closeButton =
            UIButton(type: .system)

        closeButton.setTitle(
            "Close",
            for: .normal
        )

        closeButton.setTitleColor(
            Theme.ink2,
            for: .normal
        )

        closeButton.titleLabel?.font =
            .systemFont(
                ofSize: 15.5,
                weight: .semibold
            )

        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor =
            Theme.line.cgColor

        closeButton.layer.cornerRadius = 12

        closeButton.heightAnchor.constraint(
            equalToConstant: 46
        ).isActive = true

        closeButton.addTarget(
            self,
            action: #selector(closeTapped),
            for: .touchUpInside
        )

        stack.addArrangedSubview(closeButton)
    }

    private func createBadge() -> UIView {

        let container = UIView()

        let badge =
            StatusBadgeView(
                consultation: consultation
            )

        container.addSubview(badge)

        badge.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            badge.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),

            badge.topAnchor.constraint(
                equalTo: container.topAnchor
            ),

            badge.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            )
        ])

        return container
    }

    private func createBreakdown() -> UIView {

        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 0

        stack.addArrangedSubview(
            breakdownRow(
                "Fees (listed in your profile)",
                value: "৳\(fmt(Float(consultation.fees)))"
            )
        )

        stack.addArrangedSubview(
            breakdownRow(
                "Paid Fees (after any discount)",
                value: "৳\(fmt(Float(consultation.paidFees)))"
            )
        )

        let commission =
            consultation.paidFees -
            consultation.doctorFees

        stack.addArrangedSubview(
            breakdownRow(
                "Admin Commission",
                value: "− ৳\(fmt(Float(commission)))",
                valueColor: Theme.danger
            )
        )

        let doctorRow =
            breakdownRow(
                "Doctor's Bill",
                value:
                    "৳\(fmt(Float(consultation.doctorFees)))",
                isTotal: true
            )

        stack.addArrangedSubview(
            doctorRow
        )

        return stack
    }

    private func breakdownRow(
        _ title: String,
        value: String,
        valueColor: UIColor = Theme.ink,
        isTotal: Bool = false
    ) -> UIView {

        let container = UIView()

        let left = UILabel()

        left.text = title

        left.font = .systemFont(
            ofSize: 15,
            weight:
                isTotal ? .bold : .regular
        )

        left.textColor = Theme.ink2

        let right = UILabel()

        right.text = value

        right.font = .systemFont(
            ofSize: 15,
            weight:
                isTotal ? .heavy : .regular
        )

        right.textColor = valueColor

        container.addSubview(left)
        container.addSubview(right)

        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            left.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 9
            ),

            left.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),

            left.bottomAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: -9
            ),

            right.centerYAnchor.constraint(
                equalTo: left.centerYAnchor
            ),

            right.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            )
        ])

        let line = UIView()

        line.backgroundColor = Theme.line2

        container.addSubview(line)

        line.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            line.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),

            line.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),

            line.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            ),

            line.heightAnchor.constraint(
                equalToConstant: 1
            )
        ])

        return container
    }

    private func createInfoBox(
        text: String,
        background: UIColor,
        textColor: UIColor
    ) -> UIView {

        let label = UILabel()

        label.text = text
        label.font = .systemFont(
            ofSize: 14
        )

        label.textColor = textColor
        label.numberOfLines = 0

        label.backgroundColor = background

        label.layer.cornerRadius = 10
        label.clipsToBounds = true

        label.layoutMargins =
            UIEdgeInsets(
                top: 12,
                left: 12,
                bottom: 12,
                right: 12
            )

        label.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 45
        ).isActive = true

        return label
    }

    @objc private func closeTapped() {

        dismiss(
            animated: true
        )
    }
}
