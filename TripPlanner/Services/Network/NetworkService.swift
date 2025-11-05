//
//  File.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 25/10/25.
//

import Foundation

class TripService {
    func generateTrip(location: String, days: Int) async throws -> PlanDetails {
        guard let url = URL(string: "\(baseURL)/trips/generate") else {
            throw URLError(.badURL)
        }
        
        var requestBody: [String: Any] = [:]
        requestBody["location"] = location
        requestBody["days"] = days
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let res = try decoder.decode(PlanDetails.self, from: data)
        
        CoreDataManager.shared.saveTrip(plan: res)
        return res
    }
}
