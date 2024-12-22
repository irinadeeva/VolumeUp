import SwiftUI

struct CustomSlider: View {
  @State private var sliderProgress: CGFloat = 0.5
  @State private var dragOffset: CGFloat = .zero
  @State private var lastDragOffset: CGFloat = .zero
  private let height = 150.0
  private let width = 60.0

  var body: some View {
    ZStack(alignment: .bottom) {
      Rectangle()
        .fill(.ultraThinMaterial)

      Rectangle()
        .fill(.white)
        .frame(height: height * sliderProgress)
    }
    .clipShape(.rect(cornerRadius: 15))
    .optionalSizingModifier(
      progress: sliderProgress,
      height: height
    )
    .gesture(
      DragGesture(minimumDistance: 0)
        .onChanged {
          let movement = -$0.translation.height + lastDragOffset
          dragOffset = movement
          calculateProgress(value: height)
        }
        .onEnded { _ in
          withAnimation(.smooth) {
            dragOffset = dragOffset > height ? height : (dragOffset < 0 ? 0 : dragOffset)
            calculateProgress(value: height)
          }

          lastDragOffset = dragOffset
        }
    )
    .frame(width: width, height: height, alignment: (sliderProgress < 0 ? .top : .bottom))
  }

  private func calculateProgress(value: CGFloat) {
    let topAndTrailingExcessOffset = height + (dragOffset - height) * 0.1
    let bottomAndLeadingExcessOffset = dragOffset < 0 ? dragOffset * 0.1 : dragOffset

    let progress = (dragOffset > height ? topAndTrailingExcessOffset : bottomAndLeadingExcessOffset) / height
    self.sliderProgress = progress
  }

}

struct ContentView: View {

  var body: some View {
    VStack {
      CustomSlider()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.blue)
  }
}

fileprivate extension View {
  @ViewBuilder
  func optionalSizingModifier(progress: CGFloat, height: CGFloat) -> some View {
    self
      .frame(height: progress < 0 ? height + (-progress * height) : nil)
  }
}

#Preview {
  ContentView()
}
