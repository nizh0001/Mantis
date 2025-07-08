//
//  MuCustomToolBar.swift
//  Mantis
//
//  Created by Veronika Nizhankivska on 2025-07-08.
//
import UIKit

public final class MyCustomToolbar: UIView, CropToolbarProtocol {
    public var config = CropToolbarConfig()
    public var iconProvider: CropToolbarIconProvider?
    public weak var delegate: CropToolbarDelegate?

    public func createToolbarUI(config: CropToolbarConfig) {
        self.config = config

        backgroundColor = config.backgroundColor

        let cancel = makeTextButton(title: "Cancel") {
            self.delegate?.didSelectCancel(self)
        }
        let done = makeTextButton(title: "Done") {
            self.delegate?.didSelectCrop(self)
        }

        let flip = makeIconButton(systemName: "arrow.left.and.right") {
            self.delegate?.didSelectHorizontallyFlip(self)
        }
        let rotate = makeIconButton(systemName: "rotate.right") {
            self.delegate?.didSelectCounterClockwiseRotate(self)
        }
        let reset = makeTextButton(title: "Reset") {
            self.delegate?.didSelectReset(self)
        }

        let ratioFree = makeTextButton(title: "Free") {
            self.delegate?.didSelectFreeRatio(self)
        }
        let ratio169 = makeTextButton(title: "16:9") {
            self.delegate?.didSelectRatio(self, ratio: 16.0 / 9.0)
        }
        let ratioSquare = makeTextButton(title: "1:1") {
            self.delegate?.didSelectRatio(self, ratio: 1.0)
        }

        let topRow = UIStackView(arrangedSubviews: [cancel, UIView(), done])
        topRow.axis = .horizontal
        topRow.distribution = .equalSpacing

        let middleRow = UIStackView(arrangedSubviews: [flip, rotate, reset])
        middleRow.axis = .horizontal
        middleRow.spacing = 20
        middleRow.alignment = .center

        let bottomRow = UIStackView(arrangedSubviews: [ratioFree, ratio169, ratioSquare])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 20
        bottomRow.alignment = .center

        let stack = UIStackView(arrangedSubviews: [topRow, middleRow, bottomRow])
        stack.axis = .vertical
        stack.spacing = 20

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func makeTextButton(title: String, action: @escaping () -> Void) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        if #available(iOS 14.0, *) {
            btn.addAction(UIAction(handler: { _ in action() }), for: .touchUpInside)
        } else {
            btn.addTarget(nil, action: #selector(fallbackAction), for: .touchUpInside)
        }
        return btn
    }

    private func makeIconButton(systemName: String, action: @escaping () -> Void) -> UIButton {
        let btn = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            btn.setImage(UIImage(systemName: systemName), for: .normal)
        }
        if #available(iOS 14.0, *) {
            btn.addAction(UIAction(handler: { _ in action() }), for: .touchUpInside)
        } else {
            btn.addTarget(nil, action: #selector(fallbackAction), for: .touchUpInside)
        }
        return btn
    }

    @objc private func fallbackAction() {
      
    }

    public func handleFixedRatioSetted(ratio: Double) {}
    public func handleFixedRatioUnSetted() {}
    public func getRatioListPresentSourceView() -> UIView? { nil }
    public func adjustLayoutWhenOrientationChange() {}
    public func handleCropViewDidBecomeResettable() {}
    public func handleCropViewDidBecomeUnResettable() {}
    public func handleImageAutoAdjustable() {}
    public func handleImageNotAutoAdjustable() {}
}
