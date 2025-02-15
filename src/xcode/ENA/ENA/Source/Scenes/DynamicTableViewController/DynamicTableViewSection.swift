//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

struct DynamicSection {
	enum Separators {
		case none, all, inBetween
	}
	
	enum Background {
		case none, greyBoxed
	}

	let header: DynamicHeader
	let footer: DynamicFooter
	let separators: Separators
	private let isHidden: ((DynamicTableViewController) -> Bool)?
	let background: Background
	let cells: [DynamicCell]

	func isHidden(for viewController: DynamicTableViewController) -> Bool {
		isHidden?(viewController) ?? false
	}

	private init(
		header: DynamicHeader,
		footer: DynamicFooter,
		separators: Separators,
		isHidden: ((DynamicTableViewController) -> Bool)?,
		background: Background,
		cells: [DynamicCell]) {
		self.header = header
		self.footer = footer
		self.separators = separators
		self.isHidden = isHidden
		self.background = background
		self.cells = cells
	}

	static func section(
		header: DynamicHeader = .none,
		footer: DynamicFooter = .none,
		separators: Separators = .none,
		isHidden: ((DynamicTableViewController) -> Bool)? = nil,
		background: Background = .none,
		cells: [DynamicCell]) -> Self {
		.init(
			header: header,
			footer: footer,
			separators: separators,
			isHidden: isHidden,
			background: background,
			cells: cells
		)
	}
}

extension DynamicSection {
	static func navigationSubtitle(
		text: String,
		insets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 8, right: 16),
		accessibilityIdentifier: String?,
		accessibilityTraits: UIAccessibilityTraits = .none
		) -> Self {
		.section(cells: [
			.subheadline(text: text, color: .enaColor(for: .textPrimary2), accessibilityIdentifier: accessibilityIdentifier) { _, cell, _ in
				cell.contentView.preservesSuperviewLayoutMargins = false
				cell.contentView.layoutMargins = insets
				cell.accessibilityIdentifier = accessibilityIdentifier
				cell.accessibilityTraits = accessibilityTraits
			}
		])
	}
}
