import Foundation

class BoardFormViewModel: ObservableObject {
    @Published var submissionStatus: String = ""
    @Published var shouldNavigateToKanban: Bool = false
    @Published var currentProject: ProjectResponse?
    
    func submitBoard(_ board: BoardRequest) {
        let url = ApiUrl.shared.baseURL.appendingPathComponent("api/projects")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(board)
            request.httpBody = jsonData
        } catch {
            DispatchQueue.main.async {
                self.submissionStatus = "Failed to encode board data: \(error.localizedDescription)"
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.submissionStatus = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.submissionStatus = "No data received from server"
                    return
                }
                
                if let rawString = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(rawString)")
                }
                
                let decoder = JSONDecoder()
                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom { decoder -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)
                    if let date = isoFormatter.date(from: dateStr) {
                        return date
                    }
                    throw DecodingError.dataCorruptedError(in: container,
                        debugDescription: "Invalid date format: \(dateStr)")
                }
                
                do {
                    let boardResponse = try decoder.decode(ProjectResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.submissionStatus = "Project submitted successfully"
                        self.currentProject = boardResponse
                        self.shouldNavigateToKanban = true
                        print("DEBUG: currentProject set, shouldNavigateToKanban = true")
                    }
                } catch {
                    self.submissionStatus = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
