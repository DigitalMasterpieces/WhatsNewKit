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
            content
                .padding(self.layout.prominentFeaturePadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(self.background)
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

// MARK: - Background

private extension WhatsNewView.ProminentFeatureBackground {

    /// The rounded rectangle shape of the card
    var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: self.layout.prominentFeatureCornerRadius,
            style: .continuous
        )
    }

    /// The card background, animated unless motion is reduced
    @ViewBuilder
    var background: some View {
        if !self.reduceMotion, #available(iOS 15.0, macOS 12.0, visionOS 1.0, *) {
            TimelineView(.animation) { context in
                // Rotate the gradient a full turn every six seconds
                let angle = Angle.degrees(
                    context.date.timeIntervalSinceReferenceDate
                        .truncatingRemainder(dividingBy: 6) / 6 * 360
                )
                self.decoration(angle: angle)
            }
        } else {
            self.decoration(angle: .zero)
        }
    }

    /// The card decoration layered on top of the material base
    /// - Parameter angle: The rotation angle of the gradient
    func decoration(
        angle: Angle
    ) -> some View {
        let gradient = self.gradient(angle: angle)
        let opacity = self.layout.prominentFeatureBackgroundOpacity
        return ZStack {
            // Material base (Liquid Glass where available) gives the card translucency
            self.material
            // Faint gradient tint, kept subtle so the center stays calm
            self.shape
                .fill(gradient)
                .opacity(opacity * 0.35)
            // Soft glow hugging the border and fading inward, clipped so it only bleeds inward
            self.shape
                .strokeBorder(gradient, lineWidth: self.layout.prominentFeatureBorderWidth * 2)
                .blur(radius: self.layout.prominentFeatureCornerRadius / 2)
                .clipShape(self.shape)
                .opacity(opacity)
            // Crisp gradient border
            self.shape
                .strokeBorder(gradient, lineWidth: self.layout.prominentFeatureBorderWidth)
        }
    }

    /// The material base of the card
    @ViewBuilder
    var material: some View {
        #if os(macOS)
        if #available(macOS 26.0, *) {
            Color.clear.glassEffect(.regular, in: self.shape)
        } else if #available(macOS 12.0, *) {
            self.shape.fill(.regularMaterial)
        } else {
            self.shape.fill(Color.primary.opacity(0.06))
        }
        #else
        if #available(iOS 26.0, visionOS 26.0, *) {
            Color.clear.glassEffect(.regular, in: self.shape)
        } else if #available(iOS 15.0, visionOS 1.0, *) {
            self.shape.fill(.regularMaterial)
        } else {
            self.shape.fill(Color.primary.opacity(0.06))
        }
        #endif
    }

    /// An AngularGradient built from the layout's gradient colors, rotated by a given angle
    /// - Parameter angle: The rotation angle of the gradient
    func gradient(
        angle: Angle
    ) -> AngularGradient {
        // Repeat the first color to seamlessly close the gradient loop
        var colors = self.layout.prominentFeatureGradientColors
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
