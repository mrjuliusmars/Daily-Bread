import SwiftUI

struct OnboardingFlowView: View {
    @ObservedObject var onboardingState: OnboardingState
    let onOnboardingComplete: () -> Void
    
    var body: some View {
        NavigationStack(path: $onboardingState.path) {
            OnboardingCarouselView()
                .navigationDestination(for: OnboardingFlow.self) { destination in
                    switch destination {
                    case .onboardingCarousel:
                        OnboardingCarouselView()
                        
                    case .quiz(let questionNumber):
                        QuizQuestionView(questionNumber: questionNumber)
                        
                    case .userInfo:
                        UserInfoView()
                        
                    case .creatingPlan:
                        CreatingPlanView()
                        
                    case .planReady:
                        PlanReadyView()
                    }
                }
        }
        .environmentObject(onboardingState)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("OnboardingCompleted"))) { _ in
            onOnboardingComplete()
        }
    }
}

#Preview {
    OnboardingFlowView(
        onboardingState: OnboardingState(),
        onOnboardingComplete: {}
    )
}
