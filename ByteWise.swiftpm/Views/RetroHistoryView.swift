import SwiftUI

struct RetroHistoryView: View {
    let entries: [ScoreEntry]
    
    var body: some View {
        VStack(spacing: 2) {
            Text("CONVERSION HISTORY")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.green)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.8))
            
            ForEach(entries) { entry in
                HStack(spacing: 15) {
                    Text("\(entry.decimal)")
                        .frame(width: 40, alignment: .trailing)
                    Text("=")
                    Text(entry.binary)
                    Spacer()
                    Text("+\(entry.points)")
                        .foregroundColor(.green)
                }
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
            }
        }
        .foregroundColor(.green)
        .background(Color.black.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}

// Preview provider for development
struct RetroHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RetroHistoryView(entries: [
            ScoreEntry(decimal: 42, binary: "00101010", points: 15),
            ScoreEntry(decimal: 255, binary: "11111111", points: 20),
            ScoreEntry(decimal: 128, binary: "10000000", points: 25)
        ])
        .frame(maxWidth: 300)
        .padding()
        .background(Color.gray)
    }
} 