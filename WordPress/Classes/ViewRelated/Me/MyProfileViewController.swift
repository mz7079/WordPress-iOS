import UIKit
import RxSwift
import WordPressShared

class MyProfileController: NSObject, SettingsController {
    let title = NSLocalizedString("My Profile", comment: "My Profile view title")
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
        let firstNameRow = EditableTextRow(
            title: NSLocalizedString("First Name", comment: "My Profile first name label"),
            value: settings?.firstName ?? "",
            action: viewController.push(editText(AccountSettingsChange.FirstName)))

        let lastNameRow = EditableTextRow(
            title: NSLocalizedString("Last Name", comment: "My Profile last name label"),
            value: settings?.lastName ?? "",
            action: viewController.push(editText(AccountSettingsChange.LastName)))

        let displayNameRow = EditableTextRow(
            title: NSLocalizedString("Display Name", comment: "My Profile display name label"),
            value: settings?.displayName ?? "",
            action: viewController.push(editText(AccountSettingsChange.DisplayName)))

        let aboutMeRow = EditableTextRow(
            title: NSLocalizedString("About Me", comment: "My Profile 'About me' label"),
            value: settings?.aboutMe ?? "",
            action: viewController.push(editText(AccountSettingsChange.AboutMe)))

        return ImmuTable(sections: [
            ImmuTableSection(rows: [
                firstNameRow,
                lastNameRow,
                displayNameRow,
                aboutMeRow
                ])
            ])
    }

    var immutableRows: [ImmuTableRow.Type] {
        return [EditableTextRow.self]
    }

}
