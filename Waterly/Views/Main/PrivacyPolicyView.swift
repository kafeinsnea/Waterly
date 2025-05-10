//
//  PrivacyPolicyView.swift
//  Waterly
//
//  Created by Sena Çırak on 4.03.2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading,spacing:20) {
                    Text("Effective Date: 2025-05-10")
                        .font(.subheadline)
                        .padding(.bottom, 20)
                    
                    Text("1. Introduction")
                        .font(.headline)
                    Text("""
                This privacy policy applies to the Waterly app (hereafter referred to as the "Application") for mobile devices, created by Sena Çırak (hereafter referred to as the "Service Provider") as a free service. This service is provided "AS IS". 
                """)
                    .padding(.bottom, 10)
                    Text("2. What Information Does the Application Obtain and How Is It Used?")
                        .font(.headline)
                    Text("""
                                        The Application collects the following user-provided information to personalize the experience and calculate appropriate hydration goals:
                                        - Name
                                        - Weight
                                        - Wake-up time and sleep time
                                        - Daily water intake goal
                                        - Physical activity status (whether or not the user engages in physical activity)

                                        This information is only stored locally on your device using Apple's Core Data framework. It is not uploaded, shared, or sent to any external server.
                                        """)
                                        .padding(.bottom, 10)
                                    
                                    Text("3. Does the Application Collect Precise Real-Time Location Information of the Device?")
                                        .font(.headline)
                                    Text("No. This Application does not collect any location data or track your movements.")
                                        .padding(.bottom, 10)
                                    
                                    Text("4. Do Third Parties See and/or Have Access to Information Obtained by the Application?")
                                        .font(.headline)
                                    Text("No. All user data is stored locally on your device. The Application does not share any data with third parties, and it does not send or share any data externally.")
                                        .padding(.bottom, 10)
                                    
                                    Text("5. What Are My Opt-Out Rights?")
                                        .font(.headline)
                                    Text("""
                                        You can stop all data collection by uninstalling the Application. Upon uninstallation, all locally stored data will be deleted.
                                        """)
                                        .padding(.bottom, 10)
                                    
                                    Text("6. Notifications")
                                        .font(.headline)
                                    Text("""
                                        The Waterly app sends notifications solely for the purpose of reminding you to drink water and stay hydrated. These reminders will be based on your hydration goals and daily water intake.

                                        By using the Waterly app, you agree to receive notifications related to hydration reminders. If you do not wish to receive these notifications, you can disable them at any time through your device's notification settings.

                                        We do not send any promotional notifications or notifications unrelated to hydration.
                                        """)
                                        .padding(.bottom, 10)
                                    
                                    Text("7. Children")
                                        .font(.headline)
                                    Text("""
                                        This Application is not intended for children under the age of 13. The Service Provider does not knowingly collect any personally identifiable information from children. If you believe a child has provided personal information, please contact us at senaci.dev@gmail.com, and we will take steps to delete such information.
                                        """)
                                        .padding(.bottom, 10)
                                    
                                    Text("8. Security")
                                        .font(.headline)
                                    Text("Since all data is stored locally on your device, it is protected by your device’s security mechanisms. No information is transmitted or stored externally.")
                                        .padding(.bottom, 10)
                                    
                                    Text("9. Changes")
                                        .font(.headline)
                                    Text("""
                                        This Privacy Policy may be updated from time to time. Any changes will be posted on this page, and continued use of the Application after such changes constitutes your acceptance of those changes.
                                        """)
                                        .padding(.bottom, 10)
                                    
                                    Text("10. Your Consent")
                                        .font(.headline)
                                    Text("By using the Application, you consent to the collection, storage, and use of your data as described in this Privacy Policy.")
                                        .padding(.bottom, 10)
                                    
                                    Text("11. Contact Us")
                                        .font(.headline)
                                    Text("""
                                        If you have any questions regarding this Privacy Policy, please contact us at:
                                        senaci.dev@gmail.com
                                        """)
                                        .padding(.bottom, 20)
                    
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("Privacy Policy")
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
