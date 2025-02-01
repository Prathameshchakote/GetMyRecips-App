//
//  CardGroupBoxStyle.swift
//  GetMyRecips
//
//  Created by Prathamesh on 2/2/25.
//

import Foundation
import SwiftUI

struct CardGroupBoxStyle: GroupBoxStyle {

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            configuration.label
                .font(.title2)
            
            configuration.content

        }
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
