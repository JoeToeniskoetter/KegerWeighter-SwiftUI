//
//  TrendsView.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 12/13/21.
//

import SwiftUI
import SwiftUICharts

struct TrendsView: View {
    var body: some View {
        LineView(
            data: [10,2,3],
            title: "Line chart", legend: "Full screen")
            .padding()
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
