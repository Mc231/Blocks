////
////  DraggedTetramonioChecker.swift
////  Blocks
////
////  Created by Volodymyr Shyrochuk on 6/1/19.
////  Copyright © 2019 QuasarClaster. All rights reserved.
////

import UIKit

class DraggedTetramonioChecker {
    
	
	// MARK: - Inizialization

	private let field: UICollectionView
	private let view: UIView
	

	init(field: UICollectionView, view: UIView) {
		self.field = field
		self.view = view
	}

	// MARK: - Private variables

	private var initialCenter = CGPoint()

	func handleDraggedTetramonio(from gesture: UIPanGestureRecognizer,
                                 matchingThreshold: Int = 8,
								 animationDuration: TimeInterval = 0.3,
								 completion: @escaping ([FieldCell]) -> Swift.Void) {

		guard let piece = gesture.view as? TetramonioView else { return }

		// Get the changes in the X and Y directions relative to
		// the superview's coordinate space.
		let translation = gesture.translation(in: piece.superview)
		if gesture.state == .began {
			// Save the view's original position.
			field.layer.zPosition = -1
			self.initialCenter = CGPoint(x: piece.center.x, y: piece.center.y)
		} else if gesture.state != .ended {
			// Update the position for the .began, .changed, and .ended states
			// Add the X and Y translation to the view's original position.
			let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
			piece.center = newCenter
		}else{
			let matchedCells = field
				.subviews
				.compactMap({$0 as? FieldCollectionViewCell})
				.reduce(into: [FieldCell]()) { (result, fieldCell) in
					piece.selectedCells.forEach({ (tetramonioCell) in
						let fieldRect = fieldCell.convert(fieldCell.bounds, to: self.view)
						let tetramonioRect = tetramonioCell.convert(tetramonioCell.bounds, to: self.view)
                        let matchingThreshold = 8.0
                        let intersectRect = fieldRect.insetBy(dx: -matchingThreshold, dy: -matchingThreshold)
                                            .intersection(tetramonioRect.insetBy(dx: -matchingThreshold, dy: -matchingThreshold))
						let intersectsTetramonioRect = fieldRect.intersects(tetramonioRect)
						let intersectRectSzie = intersectRect.width >= 32 && intersectRect.height >= 32
						if  intersectsTetramonioRect && intersectRectSzie,
							let data = fieldCell.cellData {
							if !result.contains(data) {
								result.append(data)
							}
						}
					})
			}
            if matchedCells.allSatisfy(\.isEmpty) {
                completion(matchedCells)
            }
			
			// On cancellation, return the piece to its original location.
			UIView.animate(withDuration: animationDuration) { [weak self] in
				self?.field.layer.zPosition = 1
				piece.center = self?.initialCenter ?? .zero
			}
		}
	}
}
