import SwiftUI

// MARK: - WhatsNewView+ProminentFeatureBackground

extension WhatsNewView {

    /// A ViewModifier that renders a feature inside a prominent, highlighted card
    struct ProminentFeatureBackground: ViewModifier {

        /// The WhatsNew Layout
        let layout: WhatsNew.Layout

        /// A Boolean value if motion should be reduced
        @Environment(\.accessibilityReduceMotion)
        private var reduceMotion

        /// The content and behavior of the modifier
        func body(
            content: Content
        ) -> some View {
            self
                .fill(
                    content
                        .padding(self.layout.prominentFeaturePadding)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .overlay(self.border)
                // Break the card out of the leading feature list padding so it spans
                // the full content width while its content stays aligned with the other features
                .padding(
                    .init(
                        top: 0,
                        leading: -self.layout.featureListPadding.leading,
                        bottom: 0,
                        trailing: -self.layout.featureListPadding.trailing
                    )
                )
        }

    }

}

// MARK: - Fill

private extension WhatsNewView.ProminentFeatureBackground {

    /// The rounded rectangle clipping shape of the card
    var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: self.layout.prominentFeatureCornerRadius,
            style: .continuous
        )
    }

    /// Applies the card background fill to a given content
    /// - Parameter content: The content the fill should be applied to
    @ViewBuilder
    func fill<Content: View>(
        _ content: Content
    ) -> some View {
        #if os(macOS)
        if #available(macOS 26.0, *) {
            content.glassEffect(.regular, in: self.shape)
        } else if #available(macOS 12.0, *) {
            content.background(.regularMaterial, in: self.shape)
        } else {
            content.background(Color.primary.opacity(0.06).clipShape(self.shape))
        }
        #else
        if #available(iOS 26.0, visionOS 26.0, *) {
            content.glassEffect(.regular, in: self.shape)
        } else if #available(iOS 15.0, visionOS 1.0, *) {
            content.background(.regularMaterial, in: self.shape)
        } else {
            content.background(Color.primary.opacity(0.06).clipShape(self.shape))
        }
        #endif
    }

}

// MARK: - Border

private extension WhatsNewView.ProminentFeatureBackground {

    /// The gradient border of the card, animated unless motion is reduced
    @ViewBuilder
    var border: some View {
        if !self.reduceMotion, #available(iOS 15.0, macOS 12.0, visionOS 1.0, *) {
            TimelineView(.animation) { context in
                // Rotate the gradient a full turn every six seconds
                let angle = Angle.degrees(
                    context.date.timeIntervalSinceReferenceDate
                        .truncatingRemainder(dividingBy: 6) / 6 * 360
                )
                self.shape
                    .strokeBorder(
                        self.gradient(angle: angle),
                        lineWidth: self.layout.prominentFeatureBorderWidth
                    )
            }
        } else {
            self.shape
                .strokeBorder(
                    self.gradient(angle: .zero),
                    lineWidth: self.layout.prominentFeatureBorderWidth
                )
        }
    }

    /// An AngularGradient built from the layout's border colors, rotated by a given angle
    /// - Parameter angle: The rotation angle of the gradient
    func gradient(
        angle: Angle
    ) -> AngularGradient {
        // Repeat the first color to seamlessly close the gradient loop
        var colors = self.layout.prominentFeatureBorderColors
        if let first = colors.first {
            colors.append(first)
        }
        return AngularGradient(
            gradient: .init(colors: colors),
            center: .center,
            angle: angle
        )
    }

}
