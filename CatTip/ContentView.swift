import SwiftUI

struct ContentView: View {
    @State private var billAmount: String = ""
    @State private var tipAmount: String = ""
    @State private var isCalculating: Bool = false
    @State private var showResult: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if !isCalculating && !showResult {
                VStack {
                    HStack {
                        Text("$")
                            .foregroundColor(.white)
                            .font(Font.custom("Slack-Light", size: 60))
                        Text(billAmount)
                            .foregroundColor(.white)
                            .font(Font.custom("Slack-Light", size: 60))
                    }
                    
                    Spacer()
                    
                    CustomKeypad(value: $billAmount)
                    
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
                            .font(Font.custom("Slack-Light", size: 30))
                        Text("$\(tipAmount)")
                            .font(Font.custom("Slack-Light", size: 80))
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
        // Add the cat chopping vegetables animation here.
        
        // Calculate the 20% tip.
        if let bill = Double(billAmount) {
            let tip = bill * 0.20
            tipAmount = String(format: "%.2f", tip)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
