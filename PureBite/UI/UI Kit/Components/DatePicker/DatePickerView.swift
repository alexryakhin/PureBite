import SwiftUI
import UIKit

struct DatePickerView: UIViewRepresentable {
    @Binding private var selection: Date
    @Binding private var isEditing: Bool
    private let minDate: Date?
    private let maxDate: Date?
    private let datePickerMode: UIDatePicker.Mode
    private let minuteInterval: Int

    private let datePicker = UIDatePicker()

    init(
        selection: Binding<Date>,
        isEditing: Binding<Bool>,
        minDate: Date?,
        maxDate: Date?,
        datePickerMode: UIDatePicker.Mode = .dateAndTime,
        minuteInterval: Int = 1
    ) {
        self._selection = selection
        self._isEditing = isEditing
        self.minDate = minDate
        self.maxDate = maxDate
        self.datePickerMode = datePickerMode
        self.minuteInterval = minuteInterval
    }

    func makeUIView(context: Context) -> UIDatePicker {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = datePickerMode
        datePicker.minuteInterval = minuteInterval
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.editingDidBegin(_:)), for: .editingDidBegin)
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.editingDidEnd(_:)), for: .editingDidEnd)
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selection
        uiView.minimumDate = minDate
        uiView.maximumDate = maxDate
        uiView.datePickerMode = datePickerMode
        uiView.minuteInterval = minuteInterval
    }

    func makeCoordinator() -> DatePickerView.Coordinator {
        Coordinator(selection: $selection, isEditing: $isEditing)
    }

    final class Coordinator: NSObject {
        private let selection: Binding<Date>
        private let isEditing: Binding<Bool>

        init(selection: Binding<Date>, isEditing: Binding<Bool>) {
            self.selection = selection
            self.isEditing = isEditing
        }

        @objc func changed(_ sender: UIDatePicker) {
            selection.wrappedValue = sender.date
        }

        @objc func editingDidBegin(_ sender: UIDatePicker) {
            selection.wrappedValue = sender.date
            isEditing.wrappedValue = true
        }

        @objc func editingDidEnd(_ sender: UIDatePicker) {
            isEditing.wrappedValue = false
        }
    }
}
