import Foundation
import UIKit
import RxSwift
import WordPressComAnalytics

class AccountSettingsController: NSObject, SettingsController {
    let title = NSLocalizedString("Account Settings", comment: "Account Settings Title");
    let service: AccountSettingsService
    let viewController = SettingsViewController()

    init(service: AccountSettingsService) {
        self.service = service
        super.init()
        viewController.title = title
        viewController.handler.registerRows(immutableRows)
        _ = viewModel
            .observeOn(MainScheduler.instance)
            .takeUntil(viewController.rx_deallocated)
            .subscribeNext(viewController.bindViewModel)
    }

    convenience init(account: WPAccount) {
        self.init(service: AccountSettingsService(userID: account.userID.integerValue, api: account.restApi))
    }

    var viewModel: Observable<ImmuTable> {
        return service.settingsObserver.map(mapViewModel)
    }

    func mapViewModel(settings: AccountSettings?) -> ImmuTable {
        let username = TextRow(
            title: NSLocalizedString("Username", comment: "Account Settings Username label"),
            value: settings?.username ?? "")

        let email = TextRow(
            title: NSLocalizedString("Email", comment: "Account Settings Email label"),
            value: settings?.email ?? "")

        let webAddress = EditableTextRow(
            title: NSLocalizedString("Web Address", comment: "Account Settings Web Address label"),
            value: settings?.webAddress ?? "",
            action: viewController.push(editWebAddress())
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

        return ImmuTable(sections: [
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

    var immutableRows: [ImmuTableRow.Type] {
        return [
            TextRow.self,
            EditableTextRow.self,
            MediaSizeRow.self,
            SwitchRow.self]
    }

    // MARK: - Actions

    func editWebAddress() -> ImmuTableRowControllerGenerator {
        return editText(AccountSettingsChange.WebAddress, hint: NSLocalizedString("Shown publicly when you comment on blogs.", comment: "Help text when editing web address"))
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


