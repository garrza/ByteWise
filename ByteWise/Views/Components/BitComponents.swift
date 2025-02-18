import SwiftUI

struct BitToggleButton: View {
    @Binding var isOn: Bool
    let position: Int
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            BitCell(value: isOn, position: position)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

