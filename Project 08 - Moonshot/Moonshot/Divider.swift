//
//  Divider.swift
//  Moonshot
//
//  Created by Sébastien Kempf on 28/12/2024.
//

import SwiftUI

struct Divider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    Divider()
}
