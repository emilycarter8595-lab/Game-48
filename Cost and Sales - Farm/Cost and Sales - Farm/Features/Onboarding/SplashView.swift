import SwiftUI

struct SplashView: View {
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Image("loading_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 373, height: 21)
                        .background(Color(red: 0.22, green: 0.23, blue: 0.37))
                        .cornerRadius(24)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 365 * progress, height: 17)
                        .background(Color.white.opacity(0.50))
                        .cornerRadius(24)
                        .padding(.leading, 4)
                }
                .frame(width: 373, height: 21)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.8)) {
                progress = 1.0
            }
        }
    }
}

#Preview {
    SplashView()
}
