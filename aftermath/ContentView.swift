import SwiftUI
import UIKit 

struct ContentView: View {
    @State private var billAmount: String = "0"
    @State private var tipAmount: String = ""
    @State private var isCalculating: Bool = false
    @State private var showResult: Bool = false
    @State private var totalAmount: String = "" // Add this new state variable
    @State private var shakeAmount: Double = 0
    
    func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func formattedCurrencyString(from value: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        // Find the decimal separator based on the current locale
        let decimalSeparator = NSLocale.current.decimalSeparator ?? "."

        // Split the entered value into integer and fractional parts
        let components = value.split(separator: Character(decimalSeparator))
        let integerPart = components.first ?? ""
        let fractionalPart = components.count > 1 ? String(components[1]) : nil

        // Convert integer part string to a number
        if let intValue = Int(integerPart),
           let formattedIntPart = formatter.string(from: NSNumber(value: intValue)) {
            // If there's a fractional part, append it back
            if let fractional = fractionalPart {
                return formattedIntPart + decimalSeparator + fractional
            } else {
                return formattedIntPart
            }
        } else {
            return value
        }
    }
    
    var billAmountFontSize: CGFloat {
        if billAmount.count >= 7 {
            return 60
        } else {
            return 74
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if !isCalculating && !showResult {
                VStack {
                    Text("bill amount")
                        .font(Font.custom("Slack-Light", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Spacer()
                    HStack {
                        Text("$")
                            .foregroundColor(.white)
                            .font(Font.custom("Slack-Light", size: billAmountFontSize))
                        Text(billAmount.isEmpty ? "0" : formattedCurrencyString(from: billAmount))
                            .foregroundColor(.white)
                            .font(Font.custom("Slack-Light", size: billAmountFontSize))
                            .rotationEffect(.degrees(shakeAmount))
                    }
                    Spacer()
                    CustomKeypad(value: $billAmount)
                        .onChange(of: billAmount) { _ in
                            limitDecimalPlaces()
                        }
                    Spacer()
                                        
                    VStack {
                        Button(action: {
                            generateHapticFeedback()
                            if billAmount == "0" {
                                // Trigger shake animation
                                withAnimation(
                                    Animation.default
                                        .repeatCount(5, autoreverses: true) // Make it shake 5 times
                                        .speed(1.5) // This will make the animation 2 times faster
                                ) {
                                    shakeAmount = 15
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    shakeAmount = 0
                                }
                                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedbackgenerator.prepare()
                                impactFeedbackgenerator.impactOccurred()
                            } else {
                                isCalculating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    calculateTip()
                                    isCalculating = false
                                    showResult = true
                                }
                            }
                        }, label: {
                            Text("uhh..")
                                .font(Font.custom("Slack-Light", size: 36))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        //.overlay(
                        //    RoundedRectangle(cornerRadius: 0)
                        //        .stroke(Color.white, lineWidth: 1)
                        //)
                    }
                }
                .padding()
            } else if isCalculating {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("hmmm....")
                        .font(Font.custom("Slack-Light", size: 36))
                        .foregroundColor(.white)
                    Spacer()
                }
            } else if showResult {
                VStack {
                    Spacer()
                    Text("your tip should be")
                        .font(Font.custom("Slack-Light", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    Text("$\(formattedCurrencyString(from: tipAmount))")
                        .font(Font.custom("Slack-Light", size: 64))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("total")
                        .font(Font.custom("Slack-Light", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)

                    Text("$\(formattedCurrencyString(from: totalAmount))")
                        .font(Font.custom("Slack-Light", size: 36))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()

                    Button(action: {
                        generateHapticFeedback()
                        billAmount = "0"
                        tipAmount = ""
                        showResult = false
                    }, label: {
                        Text("again!!!")
                            .font(Font.custom("Slack-Light", size: 36))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                }
                .padding()
            }
        }
    }
    
    func calculateTip() {
        // Calculate the 20% tip.
        if let bill = Double(billAmount) {
            let tip = bill * 0.20
            tipAmount = String(format: "%.2f", tip)
            
            let total = bill + tip // Calculate the total
            totalAmount = String(format: "%.2f", total) // Store the total
        }
    }
    
    func limitDecimalPlaces() {
        // Find the decimal separator based on the current locale
        let decimalSeparator = NSLocale.current.decimalSeparator ?? "."

        // Check if the entered amount contains a decimal separator
        if let decimalRange = billAmount.range(of: decimalSeparator) {
            let fractionalPart = billAmount[decimalRange.upperBound...]
            let integerPart = billAmount[..<decimalRange.lowerBound]
            
            if fractionalPart.count > 2 {
                // Remove extra decimal places if there are more than two
                billAmount = String(billAmount.prefix(decimalRange.lowerBound.utf16Offset(in: billAmount) + 3))
            }

            // Limit the integer part to 6 digits
            if integerPart.count > 5 {
                billAmount = String(integerPart.prefix(6)) + decimalSeparator + fractionalPart
            }
        } else {
            // If there's no decimal separator, limit the integer part to 6 digits
            if billAmount.count > 5 {
                billAmount = String(billAmount.prefix(5))
            }
        }

        if billAmount.hasPrefix("0") && billAmount.count > 1 && !billAmount.hasPrefix("0\(decimalSeparator)") {
            billAmount.remove(at: billAmount.startIndex)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
