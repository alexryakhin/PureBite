//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
 View that displays information from the touch events.
 */
internal struct TouchOverlayBox<T: CTChartData>: View {
    
    @ObservedObject private var chartData: T
    
    @Binding private var boxFrame: CGRect
    
    internal init(
        chartData: T,
        boxFrame: Binding<CGRect>
    ) {
        self.chartData = chartData
        self._boxFrame = boxFrame
    }
    
    internal var body: some View {
        Group {
            if chartData.chartStyle.infoBoxContentAlignment == .vertical {
                VStack(alignment: .center, spacing: 8) {
                    ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
                        chartData.infoDescription(info: point)
                            .font(chartData.chartStyle.infoBoxDescriptionFont)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        chartData.infoValueUnit(info: point)
                            .font(chartData.chartStyle.infoBoxValueFont)
                            .foregroundColor(chartData.chartStyle.infoBoxValueColour)
                    }
                }
            } else {
                HStack {
                    ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
                        chartData.infoLegend(info: point)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                            .layoutPriority(1)
                        chartData.infoDescription(info: point)
                            .font(chartData.chartStyle.infoBoxDescriptionFont)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                    }
                }
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if chartData.infoView.isTouchCurrent {
                    RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                        .fill(Color.black.opacity(0.00000001))
                        .onAppear {
                            self.boxFrame = geo.frame(in: .local)
                        }
                        .onChange(of: geo.frame(in: .local)) { frame in
                            self.boxFrame = frame
                        }
                }
            }
        )
    }
}
