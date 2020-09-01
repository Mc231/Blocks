//
//  DraggedTetramonioChecker.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 6/1/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import UIKit

// TODO: - add constants and refactore
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
	private var initialWidth = CGFloat.leastNonzeroMagnitude
	
	func handleDraggedTetramonio(from gesture: UIPanGestureRecognizer,
								 completion: @escaping ([CellData]) -> Swift.Void) {
		
		guard let piece = gesture.view as? TetramonioView else { return }
		
		// Get the changes in the X and Y directions relative to
		// the superview's coordinate space.
		let translation = gesture.translation(in: piece.superview)
		if gesture.state == .began {
			// Save the view's original position.
			field.layer.zPosition = -1
			self.initialCenter = CGPoint(x: piece.center.x, y: piece.center.y - 80.0)
			self.initialWidth = piece.frame.width
			let coof = (field.frame.width / 2) / initialWidth
			piece.transform = CGAffineTransform(scaleX: coof, y: coof)
		}else if gesture.state == .changed {
			//	print("Changed")
		}
		// Update the position for the .began, .changed, and .ended states
		if gesture.state != .ended {
			// Add the X and Y translation to the view's original position.
			let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
			piece.center = newCenter
		}else{
			let matchedTetramoino = field
				.subviews
				.compactMap({$0 as? FieldCell})
				.reduce(into: [CellData]()) { (result, fieldCell) in
					piece.selectedCells.forEach({ (tetramonioCell) in
						let fieldRect = fieldCell.convert(fieldCell.bounds, to: self.view)
						let tetramonioRect = tetramonioCell.convert(tetramonioCell.bounds, to: self.view)
						let intersectRect = fieldRect.intersection(tetramonioRect)
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
			completion(matchedTetramoino)
			
			// On cancellation, return the piece to its original location.
			UIView.animate(withDuration: 0.3) {
				self.field.layer.zPosition = 1
				piece.center = self.initialCenter
				let coof = self.initialWidth / piece.bounds.width
				piece.transform = CGAffineTransform(scaleX: coof, y: coof)
			}
		}
		
	}
}
