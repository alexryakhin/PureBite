//
//  WidgetErrorView.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

import SwiftUI

struct WidgetErrorView: View {

    typealias Props = DefaultErrorProps

    private let props: Props

    init(props: DefaultErrorProps) {
        self.props = props
    }

    var body: some View {
        VStack {
            Spacer()
            errorView
            Spacer()
            if let actionProps = props.actionProps {
                Button {
                    actionProps.action()
                } label: {
                    Text(actionProps.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
    }

    var errorView: some View {
        VStack(spacing: 16) {
            props.image?
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.secondary)
            VStack(spacing: 4) {
                Text(props.title)
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(props.message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .multilineTextAlignment(.center)
    }
}
