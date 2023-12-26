//
//  DetailsView.swift
//  ImageViewer
//
//  Created by Иван Легенький on 26.12.2023.
//

import SwiftUI

struct DetailView: View {
    @Binding var showDetailsView: Bool
    @Binding var detailsViewAnimation: Bool
    var post: Post
    @Binding var selectedPicID: UUID?
    var updateScrollPosition: (UUID?) -> ()
    
    @State private var startTask1: DispatchWorkItem?
    @State private var startTask2: DispatchWorkItem?
  
    
    @State private var detailsScrollPosition: UUID?
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(post.pics) { pic in
                    Image(pic.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .anchorPreference(key: OffsetKey.self, value: .bounds, transform: { anchor in
                            return ["DESTINATION \(pic.id.uuidString)": anchor]
                        })
                        .opacity(selectedPicID == pic.id ? 0 : 1)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $detailsScrollPosition)
        .background(.black)
        .opacity(detailsViewAnimation ? 1 : 0)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            Button("", systemImage: "xmark.circle.fill") {
                cancelTasks()
                updateScrollPosition(detailsScrollPosition)
                selectedPicID = detailsScrollPosition
                initiateTask(ref: &startTask1, task: .init(block: {
                    withAnimation(.snappy(duration: 0.3)) {
                        detailsViewAnimation = false
                    }
                    
                    initiateTask(ref: &startTask2, task: .init(block: {
                        showDetailsView = false
                        selectedPicID = nil
                    }), duration: 0.3)
                }), duration: 0.05)
            }
            .font(.title)
            .foregroundStyle(.white.opacity(0.8), .white.opacity(0.15))
            .padding()
        }
        .onAppear {
            cancelTasks()
            guard detailsScrollPosition == nil else { return }
            detailsScrollPosition = selectedPicID
            
            initiateTask(ref: &startTask1, task: .init(block: {
                withAnimation(.snappy(duration: 0.3)) {
                    detailsViewAnimation = true
                }
                
                initiateTask(ref: &startTask2, task: .init(block: {
                    selectedPicID = nil
                }), duration: 0.3)
            }), duration: 0.05)
        }
    }
    
    func initiateTask(ref: inout DispatchWorkItem?, task: DispatchWorkItem, duration: CGFloat) {
        ref = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    func cancelTasks() {
        if let startTask1, let startTask2 {
            startTask1.cancel()
            startTask2.cancel()
            self.startTask1 = nil
            self.startTask2 = nil
        }
    }
}
