import SwiftUI

struct Quiz_Page: View {
    
    @State private var overlayPoints: [CGPoint] = []
    
    var body: some View {
        ZStack {
            VStack{
                CameraView {overlayPoints = $0}
                    .overlay(FingersOverlay(with: overlayPoints)
                        .foregroundColor(.green)
                    )
                
                Spacer()
                
                HStack{
                    Button("여기에 문제") {
                    }
                    .frame(width: 100, height: 100)
                    
                    Button("여기에 스킵버튼") {
                    }
                    .frame(width: 100, height: 100)
                }//HStack
            }//VStack
            
            
            
            
        }//ZStack
    }
}



struct Quiz_Page_Previews: PreviewProvider {
    static var previews: some View {
        Quiz_Page()
    }
}
