import SwiftUI

struct DatePickerWithPlaceholder: View {

    enum PickerMode {
        case date
        case dateAndTime
        case time
    }

    @Binding private var date: Date?
    private let placeholder: String?
    private let minDate: Date?
    private let maxDate: Date?
    private let pickerMode: PickerMode
    private let minuteInterval: Int

    @State private var placeholderSize: CGSize = .zero
    @State private var isEditing: Bool = false

    init(
        date: Binding<Date?>,
        placeholder: String? = nil,
        minDate: Date?,
        maxDate: Date?,
        pickerMode: PickerMode,
        minuteInterval: Int = 1
    ) {
        self._date = date
        self.placeholder = placeholder
        self.minDate = minDate
        self.maxDate = maxDate
        self.pickerMode = pickerMode
        self.minuteInterval = minuteInterval
    }

    private var dateSelection: Binding<Date> {
        Binding { date ?? .now }
        set: { date = $0 }
    }

    var body: some View {
        ZStack {
            DatePickerView(
                selection: dateSelection,
                isEditing: $isEditing,
                minDate: minDate,
                maxDate: maxDate,
                datePickerMode: pickerMode.mode,
                minuteInterval: minuteInterval
            )
            .opacity(0.011)
            .frame(width: placeholderSize.width, height: placeholderSize.height)
            .clipped()
            ChildSizeReader(size: $placeholderSize) {
                pickerPlaceholder(placeholder, date: date)
                    .animation(.linear(duration: 0.1), value: date)
            }
            .allowsHitTesting(false)
        }
    }

    private func pickerPlaceholder(_ placeholder: String?, date: Date?) -> some View {
        pickerPlaceholderText(placeholder, date: date)
                .textStyle(.body)
                .foregroundColor(isEditing ? .accent : .primary)
                .padding(.horizontal, 12)
                .frame(height: 34)
                .background(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .fixedSize(horizontal: true, vertical: false)
    }

    private func pickerPlaceholderText(_ placeholder: String?, date: Date?) -> Text {
        if let date {
            Text(date, style: pickerMode.textStyle)
        } else {
            Text(placeholder ?? pickerMode.defaultText)
        }
    }
}

extension DatePickerWithPlaceholder.PickerMode {
    var textStyle: Text.DateStyle {
        switch self {
        case .date: return .date
        case .dateAndTime: return .date
        case .time: return .time
        }
    }

    var mode: UIDatePicker.Mode {
        switch self {
        case .date: return .date
        case .dateAndTime: return .dateAndTime
        case .time: return .time
        }
    }

    var defaultText: String {
        switch self {
        case .date: return "Set date"
        case .dateAndTime: return "Set date"
        case .time: return "Set time"
        }
    }
}

#Preview {
    DatePickerWithPlaceholder(
        date: .constant(nil),
        minDate: nil,
        maxDate: nil,
        pickerMode: .date
    )
}
