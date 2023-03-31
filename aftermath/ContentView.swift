import SwiftUI

struct ContentView: View {
    @State private var billAmount: String = ""
    @State private var tipAmount: String = ""
    @State private var isCalculating: Bool = false
    @State private var showResult: Bool = false
    
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
                        .multilineTextAlignment(.center) // Center the text
                        .foregroundColor(.white)
                    Spacer()
                    HStack {
                        Text("$")
                            .foregroundColor(.white)
                            .font(Font.custom("Slack-Light", size: billAmountFontSize))
                        Text(billAmount.isEmpty ? "0" : billAmount) // Display "0" when billAmount is empty, otherwise display billAmount
                            .foregroundColor(.white)
                            .font(Font.custom("Slack-Light", size: billAmountFontSize))
                    }

                    
                    Spacer()
                    
                    CustomKeypad(value: $billAmount)
                        .onChange(of: billAmount) { _ in
                            limitDecimalPlaces()
                        }
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            isCalculating = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                calculateTip()
                                isCalculating = false
                                showResult = true
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
                    VStack {
                        Text("your tip should be")
                            .font(Font.custom("Slack-Light", size: 24))
                        Text("$\(tipAmount)")
                            .font(Font.custom("Slack-Light", size: 74))
                    }
                    .multilineTextAlignment(.center) // Center the text
                    .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        billAmount = ""
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
