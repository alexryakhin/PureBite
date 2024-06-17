public enum FeatureToggle: String, CaseIterable {

    case esiaFeature = "esia_feature"
    case paymentFeature = "payment_feature"
    case promoBannersAvailable = "promo_banners_available"
    case situationsAvailable = "situations_available"
    case updateUserDataAfterAuth = "update_user_data_after_auth"
    case neededPowerCalc = "needed_power_calc"
    case connectionCostCalc = "connection_cost_calc"
    case deviceInstallmentCostCalc = "device_installment_cost_calc"
    case additionalUtilitiesCostCalc = "additional_utilities_cost_calc"
    case meteringDevicesFeature = "metering_devices_feature"
    case notificationsFeature = "notifications_feature"
    case applicationStatus = "application_status"
    case continueWithDraft = "continue_with_draft"

    case isMoreAboutApplicationEnabled = "isMoreAboutApplicationEnabled"

    public var isEnabledByDefault: Bool {
        switch self {
        case .paymentFeature,
                .connectionCostCalc:
            true
        case .promoBannersAvailable,
                .situationsAvailable,
                .esiaFeature,
                .updateUserDataAfterAuth,
                .neededPowerCalc,
                .deviceInstallmentCostCalc,
                .additionalUtilitiesCostCalc,
                .isMoreAboutApplicationEnabled,
                .meteringDevicesFeature,
                .applicationStatus,
                .continueWithDraft,
                .notificationsFeature:
            false
        }
    }

    public var title: String {
        switch self {
        case .esiaFeature:
            "Кнопка ЕСИА в профиле пользователя и при авторизации"
        case .paymentFeature:
            "Включить оплату"
        case .promoBannersAvailable:
            "Показать раздел с промо баннерами на Главной и в Услугах"
        case .situationsAvailable:
            "Показать раздел 'Ситуации' на Главной"
        case .updateUserDataAfterAuth:
            "Обновлять недостающие данные после авторизации"
        case .neededPowerCalc:
            "Калькулятор необходимой мощности"
        case .connectionCostCalc:
            "Калькулятор стоимости подключения к электросетям"
        case .deviceInstallmentCostCalc:
            "Калькулятор стоимости установки приборов учета"
        case .additionalUtilitiesCostCalc:
            "Калькулятор стоимости дополнительных услуг"
        case .meteringDevicesFeature:
            "Фича приборов учета"
        case .notificationsFeature:
            "Фича центр уведомлений"
        case .continueWithDraft:
            "Открытие черновика - показываем экран \"В разработке\" если false"
        case .applicationStatus:
            "Просмотр статуса заявки (вместо ошибок экран - \"В разработке\")"

        case .isMoreAboutApplicationEnabled:
            "Подробнее о заявке на экране статуса заявки"
        }
    }
}
