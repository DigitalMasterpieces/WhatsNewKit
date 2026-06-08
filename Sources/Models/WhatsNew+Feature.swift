import SwiftUI

// MARK: - WhatsNew+Feature

public extension WhatsNew {
    
    /// A WhatsNew Feature
    struct Feature {
        
        // MARK: Properties
        
        /// The image
        public var image: Image
        
        /// The title Text
        public var title: Text
        
        /// The subtitle Text
        public var subtitle: Text

        /// A Boolean value if the feature should be highlighted using a prominent card style
        public var isProminent: Bool

        // MARK: Initializer

        /// Creates a new instance of `WhatsNew.Feature`
        /// - Parameters:
        ///   - image: The image
        ///   - title: The title Text
        ///   - subtitle: The subtitle Text
        ///   - isProminent: A Boolean value if the feature should be highlighted using a prominent card style. Default value `false`
        public init(
            image: Image,
            title: Text,
            subtitle: Text,
            isProminent: Bool = false
        ) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.isProminent = isProminent
        }
        
    }
    
}

// MARK: - Feature+Equatable

extension WhatsNew.Feature: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.title == rhs.title
            && lhs.subtitle == rhs.subtitle
    }
    
}

// MARK: - Feature+Hashable

extension WhatsNew.Feature: Hashable {
    
    /// Hashes the essential components of this value by feeding them into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(self.title)
        hasher.combine(self.subtitle)
    }
    
}
