//
//  ContentView.swift
//  Language_Mark
//
//  Created by 양문경 on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        VStack {
            NavigationView {
                VStack {
                    Text("모두의 수화학습")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        
                    Image("hand")
                    
                    
                    HStack(spacing:50){
                        NavigationLink(destination: Study_Page()){
                            Text("학습")
                                .font(.system(size: 50))
                        }
                        
                        NavigationLink(destination: Quiz_Page()){
                            Text("퀴즈")
                                .font(.system(size: 50))
                        }
                    }
                }
                
                
            }
            
        }
        
        
        
        
       //여기까지
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
