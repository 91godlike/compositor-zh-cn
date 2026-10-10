import Foundation

/// Localizes display text only. Project values, shortcut IDs and user layer names stay intact.
nonisolated enum ChineseUI {
    private static let translations: [String: String] = {
        guard let url = Bundle.main.url(forResource: "ChineseUI", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let values = try? JSONDecoder().decode([String: String].self, from: data) else { return [:] }
        return values
    }()
    private struct Rule: @unchecked Sendable {
        let regex: NSRegularExpression
        let replacement: String
        let localizesArguments: Bool
    }
    private static let rules: [Rule] = translations.keys.filter { $0.contains("{0}") }
        .sorted { $0.count == $1.count ? $0 < $1 : $0.count > $1.count }.compactMap { key in
            let marker = try! NSRegularExpression(pattern: #"\{(\d+)\}"#)
            let nsKey = key as NSString
            let matches = marker.matches(in: key, range: NSRange(location: 0, length: nsKey.length))
            var pattern = "^", cursor = 0
            for match in matches {
                pattern += NSRegularExpression.escapedPattern(for: nsKey.substring(with: NSRange(location: cursor, length: match.range.location - cursor)))
                pattern += "(.*?)"
                cursor = NSMaxRange(match.range)
            }
            pattern += NSRegularExpression.escapedPattern(for: nsKey.substring(from: cursor)) + "$"
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else { return nil }
            let descriptorKeys: Set<String> = ["Tool › {0}", "Edit {0}.", "Choose the {0} color", "{0} color", "{0} canvas",
                "{0} the selection by this many pixels", "Color Picker ({0} Color)", "Color Picker ({0})",
                "Move selected pixels {0} 1 px", "Move selected pixels {0} 10 px", "Nudge {0} 1 px", "Nudge {0} 10 px",
                "Undo {0}", "Redo {0}", "{0}. Double-click to reset.", "{0} is assigned to both {1} and {2}."]
            return Rule(regex: regex, replacement: translations[key]!, localizesArguments: descriptorKeys.contains(key))
        }
    static func translate(_ value: String) -> String { translate(value, depth: 0) }
    private static func translate(_ value: String, depth: Int) -> String {
        guard !value.isEmpty, depth < 6 else { return value }
        if let result = translations[value] { return result }
        let range = NSRange(value.startIndex..<value.endIndex, in: value)
        for rule in rules {
            guard let match = rule.regex.firstMatch(in: value, range: range) else { continue }
            var result = rule.replacement
            for index in (1..<match.numberOfRanges).reversed() {
                guard let capture = Range(match.range(at: index), in: value) else { continue }
                let argument = String(value[capture])
                result = result.replacingOccurrences(of: "{\(index - 1)}", with: rule.localizesArguments ? translate(argument, depth: depth + 1) : argument)
            }
            return result
        }
        for ending in ["…", "..."] where value.hasSuffix(ending) {
            let base = String(value.dropLast(ending.count))
            let result = translate(base, depth: depth + 1)
            if result != base { return result + "…" }
        }
        for separator in [" › ", " · "] where value.contains(separator) {
            return value.components(separatedBy: separator).map { translate($0, depth: depth + 1) }.joined(separator: separator)
        }
        if let range = value.range(of: " (") {
            let base = String(value[..<range.lowerBound])
            let result = translate(base, depth: depth + 1)
            if result != base { return result + String(value[range.lowerBound...]) }
        }
        for prefix in ["Last Filter: ", "Delete ", "Undo ", "Redo "] where value.hasPrefix(prefix) {
            return (translations[prefix] ?? translations[String(prefix.dropLast())] ?? prefix) + " " + translate(String(value.dropFirst(prefix.count)), depth: depth + 1)
        }
        if value.hasSuffix(" by 10") {
            return translate(String(value.dropLast(6)), depth: depth + 1) + "（步幅 10）"
        }
        // Some enum descriptions deliberately use lowercase English; do not alter identifiers.
        if let pair = translations.first(where: { $0.key.caseInsensitiveCompare(value) == .orderedSame }) { return pair.value }
        return value
    }
}
nonisolated func zh(_ value: String) -> String { ChineseUI.translate(value) }
