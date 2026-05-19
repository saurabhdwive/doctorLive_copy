

import UIKit

class CustomPlayerCircularButtonView: UIButton {
  init(symbolName: String, height: CGFloat) {
    super.init(frame: .zero)
    backgroundColor = .white
    layer.cornerRadius = height / 2
    tintColor = .black
    setImage(
      UIImage(systemName: symbolName)?
        .withRenderingMode(.alwaysTemplate),
      for: .normal)
    imageView?.contentMode = .scaleAspectFit
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
