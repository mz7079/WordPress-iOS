import Foundation
import UIKit
import WordPressShared
import WordPressComAnalytics

typealias ImmuTableRowControllerGenerator = ImmuTableRow -> UIViewController

class AccountSettingsViewController: UITableViewController {
    var account: WPAccount! {
        didSet {
            self.service = AccountSettingsService(userID: account.userID.integerValue, api: account.restApi)
        }
    }

    var service: AccountSettingsService! {
        didSet {
            subscribeSettings()
        }
    }

    var settingsSubscription: AccountSettingsSubscription?

    var handler: ImmuTableViewHandler!

    required convenience init() {
        self.init(style: .Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Account Settings", comment: "Account Settings Title");

        ImmuTable.registerRows([
            TextRow.self,
            EditableTextRow.self,
            MediaSizeRow.self,
            SwitchRow.self
            ], tableView: self.tableView)
        handler = ImmuTableViewHandler(takeOver: self)

        WPStyleGuide.resetReadableMarginsForTableView(tableView)
        WPStyleGuide.configureColorsForView(view, andTableView: tableView)

        service.refreshSettings({ _ in })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if settingsSubscription == nil {
            subscribeSettings()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeSettings()
    }

    func buildViewModel(settings: AccountSettings?) {
        let username = TextRow(
            title: NSLocalizedString("Username", comment: "Account Settings Username label"),
            value: settings?.username ?? "")

        let email = EditableTextRow(
            title: NSLocalizedString("Email", comment: "Account Settings Email label"),
            value: settings?.email ?? "",
            action: push(editEmail())
        )

        let webAddress = EditableTextRow(
            title: NSLocalizedString("Web Address", comment: "Account Settings Web Address label"),
            value: settings?.webAddress ?? "",
            action: push(editWebAddress())
        )

        let uploadSize = MediaSizeRow(
            title: NSLocalizedString("Max Image Upload Size", comment: "Title for the image size settings option."),
            value: Int(MediaService.maxImageSizeSetting().width),
            onChange: mediaSizeChanged())

        let visualEditor = SwitchRow(
            title: NSLocalizedString("Visual Editor", comment: "Option to enable the visual editor"),
            value: WPPostViewController.isNewEditorEnabled(),
            onChange: visualEditorChanged()
        )

        handler.viewModel = ImmuTable(sections: [
            ImmuTableSection(
                rows: [
                    username,
                    email,
                    webAddress
                ]),
            ImmuTableSection(
                headerText: NSLocalizedString("Media", comment: "Title label for the media settings section in the app settings"),
                rows: [
                    uploadSize
                ],
                footerText: nil),
            ImmuTableSection(
                headerText: NSLocalizedString("Editor", comment: "Title label for the editor settings section in the app settings"),
                rows: [
                    visualEditor
                ],
                footerText: nil)
            ])
    }

    func subscribeSettings() {
        settingsSubscription = service.subscribeSettings({
            [unowned self]
            (settings) -> Void in

            DDLogSwift.logDebug("Got settings \(settings)")
            self.buildViewModel(settings)
        })
    }

    func unsubscribeSettings() {
        settingsSubscription = nil
    }

    func editEmail() -> ImmuTableRowControllerGenerator {
        return editText(AccountSettingsChange.Email, hint: NSLocalizedString("Will not be publicly displayed", comment: "Help text when editing email"))
    }

    func editWebAddress() -> ImmuTableRowControllerGenerator {
        return editText(AccountSettingsChange.WebAddress, hint: NSLocalizedString("Shown publicly when you comment on blogs.", comment: "Help text when editing web address"))
    }

    func editText(changeType: (AccountSettingsChangeWithString), hint: String? = nil) -> ImmuTableRowControllerGenerator {
        return { [unowned self] row in
            let row = row as! EditableTextRow
            return self.controllerForEditableText(row, changeType: changeType, hint: hint)
        }
    }

    func push(controllerGenerator: ImmuTableRowControllerGenerator) -> ImmuTableAction {
        return {
            [unowned self]
            row in

            let controller = controllerGenerator(row)

            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func controllerForEditableText(row: EditableTextRow, changeType: (AccountSettingsChangeWithString), hint: String? = nil, isPassword: Bool = false) -> SettingsTextViewController {
        let title = row.title
        let value = row.value

        let controller = SettingsTextViewController(
            text: value,
            placeholder: "\(title)...",
            hint: hint,
            isPassword: isPassword)

        controller.title = title
        controller.onValueChanged = {
            [unowned self]
            value in

            let change = changeType(value)
            self.service.saveChange(change)
            DDLogSwift.logDebug("\(title) changed: \(value)")
        }

        return controller
    }
    
    func mediaSizeChanged() -> Int -> Void {
        return {
            value in
            let size = CGSize(width: value, height: value)
            MediaService.setMaxImageSizeSetting(size)
        }
    }

    func visualEditorChanged() -> Bool -> Void {
        return {
            enabled in
            if enabled {
                WPAnalytics.track(.EditorToggledOn)
            } else {
                WPAnalytics.track(.EditorToggledOff)
            }
            WPPostViewController.setNewEditorEnabled(enabled)
        }
    }
}

