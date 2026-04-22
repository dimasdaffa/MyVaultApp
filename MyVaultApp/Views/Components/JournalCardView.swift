//
//  JournalCard.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 21/04/26.
//

import SwiftUI

struct JournalCardView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 15){
            Text("Journal 1")
                .font(.system(size: 24))
                .bold()
            VStack(alignment: .leading){
                HStack{
                    Text("Review your mood and your \nbank account one last time \nbefore making the call.")
                        .fontWeight(.light)
                        .font(.system(size: 18))
                    Spacer()
                    Image(systemName: "square.and.pencil")
                }
//                HStack{
//                    Image(systemName: "link")
//                    Text("http://foot.com/nb740")
//                        .underline()
//                }
            }
            .font(.system(size: 27))
            
        }
        .background(
            RoundedRectangle(cornerRadius: 42)
                .fill(Color.themeCard)
                .padding(-25)
                
        )
        .padding(.horizontal,50)
    }
}

#Preview {
    JournalCardView()
}
