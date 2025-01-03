//
//  WaveView.swift
//  WaterTracking
//
//  Created by Sena Çırak on 19.12.2024.
//
//
//import SwiftUI
//
//struct WaveView: View {
//    
//    @Binding var progress : CGFloat
//    @State var startAnimation:CGFloat = 0.0
//    
//    var body: some View {
//        VStack{
//            GeometryReader{ proxy in
//                let size = proxy.size
//                ZStack{
////                    Image(systemName: "circle.fill")
////                        .resizable()
////                        .aspectRatio(contentMode: .fit)
////                        .foregroundStyle(Color.blue.opacity(0.3))
//                      
//                        
//                    WaterWave(progress: progress, waveHeight: 0.06, offset: startAnimation)
//                        .fill(Color.blue)
//                        .overlay(content: {
//                            Circle()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(width: 20,height: 20)
//                                .offset(x:20)
//                            Circle()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(width: 10,height: 10)
//                                .offset(x:-40,y:90)
//                            Circle()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(width: 40,height: 40)
//                                .offset(x: 80, y:40)
//                            Circle()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(width: 30,height: 35)
//                                .offset(x: 25, y:100)
//                            Circle()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(width: 20,height: 20)
//                                .offset(x:-90,y:70)
//                        })
////                        .mask{
////                            Image(systemName: "circle.fill")
////                                .resizable()
////                                .aspectRatio(contentMode: .fit)
////                                .foregroundStyle(Color.blue)
////                        }
//                }
//                .frame(width: size.width, height: size.height, alignment: .center)
//                .onAppear{
//                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)){
//                        startAnimation = size.width
//                    }
//                }
//            }
//            .frame(height: 260)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//    }
//}
//
//#Preview {
//    @Previewable @State var progress: CGFloat = 0.1
//    return WaveView(progress: $progress)
//}
//
//
//struct WaterWave: Shape {
//    var progress:CGFloat
//    var waveHeight:CGFloat
//    var offset:CGFloat
//    var animatableData: CGFloat{
//        get{offset}
//        set{offset = newValue}
//    }
//    
//    func path(in rect: CGRect) -> Path {
//        return Path{ path in
//            path.move(to: .zero)
//            let progressHeight: CGFloat = (1-progress) * rect.height
//            let height = waveHeight * rect.height
//            
//            for value in stride(from: 0, to: rect.width, by: 2){
//                let x: CGFloat = value
//                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
//                let y: CGFloat = progressHeight + (height * sine)
//                
//                path.addLine(to: CGPoint(x: x, y: y))
//            }
//            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
//            path.addLine(to: CGPoint(x: 0, y: rect.height))
//        }
//        
//    }
//    
//}
import SwiftUI

struct WaveView: View {
    
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    @ObservedObject var user: UserModel
    
    var body: some View {
        ZStack {
            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: Double(user.progressPercentage))
                .fill(Color.blue)
                .ignoresSafeArea(.all)
            
            Text("\(user.progressPercentage)%")
                .font(.system(size: 70))
                .fontWeight(.bold)
           
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct Wave: Shape {
    
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct InvisibleSlider: View {
    
    @Binding var percent: Double
    
    var body: some View {
        GeometryReader { geo in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.percent = max(0, min(100, percent * 100))
                }
            
            Rectangle()
                .opacity(0.001)
                .frame(width: geo.size.width, height: geo.size.height)
                .gesture(dragGesture)
        }
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(user: UserModel(context: PersistenceController.shared.container.viewContext))
    }
}
