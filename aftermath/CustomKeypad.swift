import SwiftUI
import UIKit

struct CustomKeypad: View {
    @Binding var value: String
    
    func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ForEach(0..<3) { row in
                HStack(alignment: .center, spacing: 16) {
                    ForEach(1..<4) { col in
                        let num = row * 3 + col
                        Button(action: {
                            generateHapticFeedback()
                            value += "\(num)"
                        }) {
                            Text("\(num)")
                                .font(Font.custom("Slack-Light", size: 48))
                                .frame(width: 100, height: 64)
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            HStack(alignment: .center, spacing: 16) {
                Button(action: {
                    generateHapticFeedback()
                    // Handle decimal point insertion
                    if !value.contains(".") {
                        value += "."
                    }
                }) {
                    Text(".")
                        .font(Font.custom("Slack-Light", size: 48))
                        .frame(width: 100, height: 64)
                        .foregroundColor(.white)
                }

                Button(action: {
                    generateHapticFeedback()
                    value += "0"
                }) {
                    Text("0")
                        .font(Font.custom("Slack-Light", size: 48))
                        .frame(width: 100, height: 64)
                        .foregroundColor(.white)
                }

                Button(action: {
                    generateHapticFeedback()
                    if !value.isEmpty {
                        value.removeLast()
                    }
                }) {
                    Image(systemName: "delete.left")
                        .font(.title) // Revert back to system font for icons
                        .frame(width: 100, height: 64)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct CustomKeypad_Previews: PreviewProvider {
    @State static var value = ""

    static var previews: some View {
        CustomKeypad(value: $value)
    }
}
