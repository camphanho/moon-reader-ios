//
//  ErrorHandler.swift
//  MoonReader
//
//  Error Handler - xử lý lỗi thống nhất
//

import SwiftUI

enum AppError: LocalizedError {
    case bookNotFound
    case parseError(String)
    case importError(String)
    case databaseError(String)
    case networkError(String)
    case fileError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .bookNotFound:
            return "Không tìm thấy sách"
        case .parseError(let message):
            return "Lỗi parse: \(message)"
        case .importError(let message):
            return "Lỗi import: \(message)"
        case .databaseError(let message):
            return "Lỗi database: \(message)"
        case .networkError(let message):
            return "Lỗi mạng: \(message)"
        case .fileError(let message):
            return "Lỗi file: \(message)"
        case .unknown:
            return "Lỗi không xác định"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .bookNotFound:
            return "Vui lòng kiểm tra lại file sách"
        case .parseError:
            return "File có thể bị hỏng hoặc không đúng định dạng"
        case .importError:
            return "Vui lòng thử lại hoặc kiểm tra quyền truy cập file"
        case .databaseError:
            return "Vui lòng khởi động lại app"
        case .networkError:
            return "Vui lòng kiểm tra kết nối mạng"
        case .fileError:
            return "Vui lòng kiểm tra quyền truy cập file"
        case .unknown:
            return "Vui lòng thử lại sau"
        }
    }
}

struct ErrorView: View {
    let error: Error
    let onRetry: (() -> Void)?
    
    init(error: Error, onRetry: (() -> Void)? = nil) {
        self.error = error
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Đã xảy ra lỗi")
                .font(.title2)
                .bold()
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let appError = error as? AppError,
               let suggestion = appError.recoverySuggestion {
                Text(suggestion)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if let onRetry = onRetry {
                Button("Thử lại") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

struct ErrorAlert: ViewModifier {
    @Binding var error: Error?
    let onDismiss: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert("Lỗi", isPresented: .constant(error != nil), presenting: error) { error in
                Button("OK") {
                    self.error = nil
                    onDismiss?()
                }
                
                if let appError = error as? AppError,
                   appError.recoverySuggestion != nil {
                    Button("Thử lại") {
                        self.error = nil
                        onDismiss?()
                    }
                }
            } message: { error in
                if let appError = error as? AppError,
                   let suggestion = appError.recoverySuggestion {
                    Text("\(error.localizedDescription)\n\n\(suggestion)")
                } else {
                    Text(error.localizedDescription)
                }
            }
    }
}

extension View {
    func errorAlert(error: Binding<Error?>, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ErrorAlert(error: error, onDismiss: onDismiss))
    }
}

