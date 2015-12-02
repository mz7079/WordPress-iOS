import Foundation
import UIKit
import WordPressShared.WPTableViewCell

class WPReusableTableViewCell: WPTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.image = nil
        accessoryType = .None
        selectionStyle = .Default
    }
}

class WPTableViewCellDefault: WPReusableTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class WPTableViewCellSubtitle: WPReusableTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class WPTableViewCellValue1: WPReusableTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class WPTableViewCellValue2: WPReusableTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

struct NavigationItemRow : CustomImmuTableRow {
    typealias CellType = WPTableViewCellDefault

    let title: String
    let action: ImmuTableActionType?

    func configureCell(cell: UITableViewCell) {
        let cell = cell as! CellType

        cell.textLabel?.text = title
        cell.accessoryType = .DisclosureIndicator

        WPStyleGuide.configureTableViewCell(cell)
    }
}

struct EditableTextRow : CustomImmuTableRow {
    typealias CellType = WPTableViewCellValue1

    let title: String
    let value: String
    let action: ImmuTableActionType?

    func configureCell(cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value
        cell.accessoryType = .DisclosureIndicator

        WPStyleGuide.configureTableViewCell(cell)
    }
}

struct TextRow : CustomImmuTableRow {
    typealias CellType = WPTableViewCellValue1

    let title: String
    let value: String
    let action: ImmuTableActionType? = nil

    func configureCell(cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value
        cell.selectionStyle = .None

        WPStyleGuide.configureTableViewCell(cell)
    }
}

struct LinkRow : CustomImmuTableRow {
    typealias CellType = WPTableViewCellValue1

    let title: String
    let action: ImmuTableActionType?

    func configureCell(cell: UITableViewCell) {
        cell.textLabel?.text = title

        WPStyleGuide.configureTableViewActionCell(cell)
    }
}

struct LinkWithValueRow : CustomImmuTableRow {
    typealias CellType = WPTableViewCellValue1

    let title: String
    let value: String
    let action: ImmuTableActionType?

    func configureCell(cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value

        WPStyleGuide.configureTableViewActionCell(cell)
    }
}