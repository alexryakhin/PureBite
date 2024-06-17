import SwiftUI

struct SpinnerView: View {

    private let color: UIColor
    private let rotationTime: Double = 0.75
    private let animationTime: Double = 1.9 // Sum of all animation times
    private let fullRotation: Angle = .degrees(360)
    private static let initialDegree: Angle = .degrees(270)

    @State private var spinnerStart: CGFloat = 0.0
    @State private var spinnerEndS1: CGFloat = 0.03
    @State private var spinnerEndS2S3: CGFloat = 0.03

    @State private var rotationDegreeS1 = initialDegree
    @State private var rotationDegreeS2 = initialDegree
    @State private var rotationDegreeS3 = initialDegree

    init(color: UIColor = .accent) {
        self.color = color
    }

    var body: some View {
        ZStack {
            spinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: color)
            spinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: color)
            spinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: color)
        }
        .onAppear {
            animateSpinner()
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { _ in
                animateSpinner()
            }
        }
    }

    private func spinnerCircle(start: CGFloat, end: CGFloat, rotation: Angle, color: UIColor) -> some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .fill(color.swiftUIColor)
            .rotationEffect(rotation)
    }

    // MARK: - Animation methods
    private func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: rotationTime)) {
                completion()
            }
        }
    }

    private func animateSpinner() {
        animateSpinner(with: rotationTime) { spinnerEndS1 = 1.0 }

        animateSpinner(with: (rotationTime * 2) - 0.025) {
            rotationDegreeS1 += fullRotation
            spinnerEndS2S3 = 0.8
        }

        animateSpinner(with: (rotationTime * 2)) {
            spinnerEndS1 = 0.03
            spinnerEndS2S3 = 0.03
        }

        animateSpinner(with: (rotationTime * 2) + 0.0525) { rotationDegreeS2 += fullRotation }

        animateSpinner(with: (rotationTime * 2) + 0.225) { rotationDegreeS3 += fullRotation }
    }
}

#Preview {
    SpinnerView()
        .frame(width: 24, height: 24)
}
