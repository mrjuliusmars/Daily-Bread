//
//  BlockingTimeEditorView.swift
//  Daily Bread
//
//  Editor for selecting daily blocking time
//

import SwiftUI
import FamilyControls

struct BlockingTimeEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scheduleManager = ScheduleManager()
    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    @State private var isVisible = false
    
    init() {
        let hour24 = UserDefaults.standard.object(forKey: "blockingHour") as? Int ?? 14
        let minute = UserDefaults.standard.object(forKey: "blockingMinute") as? Int ?? 37
        
        // Convert 24-hour to 12-hour for picker (1-12 range)
        let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
        
        _selectedHour = State(initialValue: hour12) // Store 12-hour format (1-12)
        _selectedMinute = State(initialValue: minute)
        
        // Store AM/PM state separately
        _isAM = State(initialValue: hour24 < 12)
    }
    
    @State private var isAM: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Royal blue gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.3, blue: 0.55),
                        Color(red: 0.1, green: 0.2, blue: 0.45),
                        Color(red: 0.05, green: 0.1, blue: 0.35)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                                    .padding(12)
                                    .background(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Text("Blocking Time")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            
                            Spacer()
                            
                            // Balance
                            Spacer()
                                .frame(width: 44)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : -20)
                    .animation(.easeOut(duration: 0.4), value: isVisible)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Info Banner
                            HStack(spacing: 12) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Choose Your Daily Blocking Time")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                    
                                    Text("Apps will automatically block at this time each day")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isVisible)
                            
                            // Time Picker
                            VStack(spacing: 16) {
                                // 12-hour time display
                                Text("Selected Time")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.7))
                                
                                Text(getTimeString())
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .scaleEffect(isVisible ? 1.0 : 0.9)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                            
                            // Apple-style Time Picker with three columns
                            ZStack {
                                // Highlight bar (Apple-style selection indicator)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 44)
                                    .padding(.horizontal, 8)
                                
                                HStack(spacing: 8) {
                                    // Hour Picker
                                    Picker("Hour", selection: $selectedHour) {
                                        ForEach(1...12, id: \.self) { hour in
                                            Text("\(hour)")
                                                .font(.system(size: 22, weight: .regular, design: .default))
                                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                                .tag(hour)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 70)
                                    .onChange(of: selectedHour) { oldValue, newValue in
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                    }
                                    
                                    // Minute Picker
                                    Picker("Minute", selection: $selectedMinute) {
                                        ForEach(Array(stride(from: 0, to: 60, by: 1)), id: \.self) { minute in
                                            Text(String(format: "%02d", minute))
                                                .font(.system(size: 22, weight: .regular, design: .default))
                                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                                .tag(minute)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 70)
                                    .onChange(of: selectedMinute) { oldValue, newValue in
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                    }
                                    
                                    // AM/PM Picker (Apple-style third column)
                                    Picker("AM/PM", selection: $isAM) {
                                        Text("AM")
                                            .font(.system(size: 22, weight: .regular, design: .default))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                            .tag(true)
                                        Text("PM")
                                            .font(.system(size: 22, weight: .regular, design: .default))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                            .tag(false)
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 60)
                                    .onChange(of: isAM) { oldValue, newValue in
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                            .frame(height: 216)
                            .clipped()
                            .padding(.horizontal, 24)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
                            
                            // Save Button
                            Button(action: {
                                saveBlockingTime()
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Save Blocking Time")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 1.0, green: 0.976, blue: 0.945))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .scaleEffect(isVisible ? 1.0 : 0.9)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                        }
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
    
    private func getTimeString() -> String {
        let amPm = isAM ? "AM" : "PM"
        return String(format: "%d:%02d %@", selectedHour, selectedMinute, amPm)
    }
    
    private var hour24: Int {
        // Convert 12-hour picker value to 24-hour format
        if isAM {
            return selectedHour == 12 ? 0 : selectedHour
        } else {
            return selectedHour == 12 ? 12 : selectedHour + 12
        }
    }
    
    private func saveBlockingTime() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Convert 12-hour picker to 24-hour format for storage
        let hour24ToSave = hour24
        
        // Save to UserDefaults (in 24-hour format)
        UserDefaults.standard.set(hour24ToSave, forKey: "blockingHour")
        UserDefaults.standard.set(selectedMinute, forKey: "blockingMinute")
        UserDefaults.standard.synchronize()
        
        print("✅ Blocking time saved: \(getTimeString())")
        print("   - Hour (24h): \(hour24ToSave)")
        print("   - Minute: \(selectedMinute)")
        
        // Re-register the schedule with new time
        Task { @MainActor in
            // Get saved app selection
            if let savedData = UserDefaults.standard.data(forKey: "selectedApps"),
               let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: savedData) {
                await scheduleManager.applyDailyBlocking(applicationTokens: decoded.applicationTokens)
            }
        }
        
        dismiss()
    }
}

#Preview {
    BlockingTimeEditorView()
}

