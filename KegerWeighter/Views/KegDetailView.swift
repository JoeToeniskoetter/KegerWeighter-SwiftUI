//
//  KegDetailView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/3/21.
//

import SwiftUI
import SwiftUICharts
import BottomSheet

struct KegDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsStore:SettingsStore
    @StateObject var keg: KegViewModel
    @State private var index = 0
    @State private var animatedBeers = 0
    @State private var oldBeersLeft = 0
    @State private var textColor: Color = Color.black
    @State private var showEditForm:Bool = false
    @State private var data: [Double] = [Double]()
    @State private var showResetKegSheet: Bool = false
    
    
    var body: some View {
        ScrollView{
            ZStack{
                VStack{
                    
                }.frame(height: UIScreen.main.bounds.height)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.blue)
                    .ignoresSafeArea(.all, edges: .top)
                    .frame(height: UIScreen.main.bounds.height * 0.35)
                VStack{
                    Spacer()
                    HStack{
                        Image(systemName:"chevron.backward.circle.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                        Image(systemName:"square.and.pencil")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                            .onTapGesture {
                                self.showEditForm.toggle()
                            }
                    }.frame(width:UIScreen.main.bounds.width)
                    
                    HStack{
                        Spacer()
                        VStack{
                            Text(self.keg.beerType).foregroundColor(.white).font(.system(size:50)).fontWeight(.bold)
                            Text(self.keg.location + " - " + self.keg.kegSize.rawValue).foregroundColor(.white).font(.system(size:20))
                        }.padding()
                        Spacer()
                    }.frame(width:UIScreen.main.bounds.width)
                    ZStack{
                        RoundedRectangle(cornerRadius: 40.0)
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .frame(height:100)
                        HStack{
                            Spacer()
                            VStack{
                                Group{
                                    Text(String(self.animatedBeers))
                                        .font(.system(size:40))
                                        .bold()
                                        .foregroundColor(self.textColor)
                                        .onAppear(perform:{
                                            self.updateOldBeers()
                                        })
                                        .onChange(of: self.keg.beersLeft, perform: { newValue in
                                            self.updateAndRunAnimation(newValue: newValue)
                                        })
                                    Text("Beers (" + self.settingsStore.beerSize.rawValue + ")").font(.subheadline)
                                }
                            }
                            Spacer()
                            VStack{
                                Text(self.calcTemperature())
                                    .font(.system(size:40))
                                    .bold()
                                Text("Degrees")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                    
                }
            }
            ZStack{
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .frame(height: UIScreen.main.bounds.height * 0.75)
                VStack {
                    TrendCellsView(index:self.$index, keg:self.keg, updateIndex:updateIndex)
                    LineView(
                        data: self.getChartData(),
                        title: self.getChartTitle(),
                        style: ChartStyle(backgroundColor: Color.white, accentColor: Colors.BorderBlue, secondGradientColor: Colors.BorderBlue,
                                          textColor: Color.black, legendTextColor: Color.black,
                                          dropShadowColor: Color.gray
                                         )
                    ).padding()
                    Spacer()
                }.onChange(of: self.keg.potentialNewKeg, perform: {newValue in
                    self.checkForNewKeg()
                })
                    .navigationBarHidden(true)
                    .padding()
                
            }.onAppear(perform: {
                self.checkForNewKeg()
            })
                .onChange(of: self.keg.potentialNewKeg, perform: { newValue in
                    self.showResetKegSheet = newValue
                })
        } .bottomSheet(
            isPresented: self.$showResetKegSheet,
            height: 400,
            topBarHeight: 20,
            topBarCornerRadius: 45,
            showTopIndicator: true
        ) {
            ResetKegView(vm: self.keg, loading: self.$keg.loading)
        }
        .sheet(isPresented: self.$showEditForm) {
            
        } content: {
            EditKegFormView(kegViewModel: self.keg)
        }
    }
    
    func checkForNewKeg(){
        if self.keg.potentialNewKeg{
            self.showResetKegSheet=true
        }
    }
    
    func updateIndex(newIndex:Int){
        withAnimation{
            self.index = newIndex
        }
    }
    
    func updateAndRunAnimation(newValue: Int){
        
        var convertedVal = newValue
        
        if self.settingsStore.beerSize == .sixteenOz{
            let tempNew = Double(newValue) * 0.75
            convertedVal = Int(tempNew)
        }
        
        self.runCounter(
            counter: self.$animatedBeers,
            start: self.oldBeersLeft,
            end: convertedVal,
            speed: 0.05
        )
        self.oldBeersLeft = newValue
    }
    
    func getChartTitle()-> String{
        if self.index == 0 {
            return "Daily Beers"
        }
        
        if self.index == 1 {
            return "Weekly Beers"
        }
        
        return "Monthly Beers"
    }
    
    func getChartData()->[Double] {
        if self.index == 0 {
            return self.keg.beersDailyArray
        }
        
        if self.index == 1 {
            return self.keg.beersWeeklyArray
        }
        
        return self.keg.beersMonthlyArray
    }
    
    func updateOldBeers(){
        if self.settingsStore.beerSize == .sixteenOz{
            let tempOld = Double(self.keg.beersLeft) * 0.75
            self.oldBeersLeft = Int(tempOld)
            self.animatedBeers = Int(tempOld)
        }else{
            self.oldBeersLeft = self.keg.beersLeft
            self.animatedBeers = self.keg.beersLeft
        }
    }
    
    func calcTemperature() -> String{
        if settingsStore.tempType == .celcius{
            return "\(String((self.keg.temp - 32) * 5/9))\u{2103}"
        }else{
            return "\(String(self.keg.temp))\u{2109}"
        }
    }
    
    func runCounter(counter: Binding<Int>, start: Int, end: Int, speed: Double) {
        counter.wrappedValue = start
        
        if start > end {
            Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                
                withAnimation{
                    self.textColor = Color.red
                }
                counter.wrappedValue -= 1
                
                if counter.wrappedValue == end {
                    timer.invalidate()
                    withAnimation{
                        self.textColor = Color.black
                    }
                }
            }
        }else{
            
            Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                
                withAnimation{
                    self.textColor = Color.green
                }
                counter.wrappedValue += 1
                if counter.wrappedValue == end {
                    timer.invalidate()
                    withAnimation{
                        self.textColor = Color.black
                    }
                }
            }
        }
    }
}


struct TrendCellsView: View {
    @Binding var index: Int
    @ObservedObject var keg: KegViewModel
    var updateIndex: (_ newIndex:Int) -> Void
    
    var sections = [
        [
            "title":"Beers",
            "subTitle":"Today"
        ],
        [
            "title":"This",
            "subTitle":"Week"
        ],
        [
            "title":"This",
            "subTitle":"Month"
        ]
    ]
    
    var body: some View{
        HStack{
            ForEach(0..<sections.count) { i in
                HStack{
                    Image(systemName:self.getTrendImage(data: self.getDataArray(index: i)))
                        .foregroundColor(self.getTrendImageColor(data: self.getDataArray(index: i)))
                    Text(String(format: "%.0f", self.getBeers(index: i)))
                        .font(.system(size: 30.0))
                        .fontWeight(.bold)
                    VStack{
                        Text(sections[i]["title"]!)
                        Text(sections[i]["subTitle"]!)
                    }
                    
                }
                .frame(width:UIScreen.main.bounds.width * 0.30, height:80)
                .onTapGesture(perform: {
                    self.updateIndex(i)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 15.0).fill(.gray.opacity(self.index == i ? 0.2 : 0.0))
                )
                if i < sections.count {
                    Spacer()
                }
            }
        }
    }
    
    func getDataArray(index:Int)->[Double]{
        if index == 0 {
            return self.keg.beersDailyArray
        }
        if index == 1 {
            return self.keg.beersWeeklyArray
        }
        return self.keg.beersMonthlyArray
    }
    
    func getBeers(index:Int) -> Double{
        if index == 0 {
            return self.keg.beersDailyArray[0]
        }
        if index == 1 {
            return self.keg.beersWeeklyArray[0]
        }
        return self.keg.beersMonthlyArray[0]
    }
    
    func getTrendImage(data: [Double])->String{
        if data.count < 2{
            return "arrowtriangle.up.fill"
        }
        
        if data[0] < data[1]{
            return "arrowtriangle.down.fill"
        }
        
        if data[0] > data[1]{
            return "arrowtriangle.up.fill"
        }
        
        return "rectangle.fill"
    }
    
    func getTrendImageColor(data:[Double])->Color{
        if data.count < 2{
            return .green
        }
        
        if data[0] < data[1]{
            return .red
        }
        
        if data[0] > data[1]{
            return .green
        }
        
        return .gray
    }
}

struct UpOrDownArrow:View{
    var arr: [Double]
    var body: some View{
        if(arr.count < 2){
            Image(systemName: "rectangle.fill").foregroundColor(.black)
        }else if arr[0] > arr[1]{
            Image(systemName:"arrowtriangle.up.fill").foregroundColor(.green)
        }else{
            Image(systemName:"arrowtriangle.down.fill").foregroundColor(.red)
        }
    }
}



struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}

struct KegDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KegDetailView(keg: KegViewModel(keg: Keg(
            beerType: "Bud Select",
            online:true,
            location: "Basement 2",
            kegSize: .halfBarrel,
            firstNotificationPerc: 0,
            secondNotificationPerc: 0,
            subscribed: false,
            data : KegData(
                customTare: 0,
                beersLeft:90,
                weight:10,
                percLeft: 0.0,
                temp: 30,
                beersToday:0,
                beersDaily: [
                    "12/13/2021":10,
                    "12/14/2021":0,
                    "12/15/2021":0,
                    "12/16/2021":10
                ],
                beersDailyArray: [10,4,5,6,7],
                beersThisWeek: 0,
                beersWeekly: [:],
                beersWeeklyArray: [10,12,0,0,0],
                beersThisMonth: 0,
                beersMonthly: [:],
                beersMonthlyArray:[10,10,0,0,0],
                firstNotificationSent: false,
                secondNotificationSent: false
            ),
            createdAt:0,
            potentialNewKeg: true
        )))
            .environmentObject(SettingsStore())
    }
}


struct RoundedRectangleButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(self.backgroundColor.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
