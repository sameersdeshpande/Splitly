import SwiftUI

struct DonutChart: View {
    var userPayerCount: Int
    var otherPayerCount: Int
    
    // Total payer count (user + others)
    private var totalPayerCount: Int {
        return userPayerCount + otherPayerCount
    }
    
    // Angle for user and others
    private var userAngle: Double {
        return (totalPayerCount == 0) ? 0 : (Double(userPayerCount) / Double(totalPayerCount)) * 360
    }
    
    private var otherAngle: Double {
        return (totalPayerCount == 0) ? 0 : (Double(otherPayerCount) / Double(totalPayerCount)) * 360
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Donut chart (Circle with slices)
            ZStack {
                // Outer ring (Background)
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                
                // User's portion (colored)
                Circle()
                    .trim(from: 0, to: CGFloat(userAngle / 360))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(.blue)
                
                // Others' portion (colored)
                Circle()
                    .trim(from: CGFloat(userAngle / 360), to: 1)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(.purple)
                
                // Inner Circle (hole of donut)
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                
                // Text inside the circle: "Who pays the most?"
                Text("Who pays the most?")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: 100, maxHeight: 60)
            }
            .frame(width: 120, height: 120)
            
            // Labels next to the donut chart
            VStack(alignment: .leading, spacing: 10) {
                Text("You")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text("\(userPayerCount)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Others")
                    .font(.subheadline)
                    .foregroundColor(.purple)
                Text("\(otherPayerCount)")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .padding()
    }
}
