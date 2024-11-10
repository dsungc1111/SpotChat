//
//  SignInVM.swift
//  SpotChat
//
//  Created by 최대성 on 11/5/24.
//

import Foundation
import Combine


final class SignInVM: BaseVMProtocol {
    
    
    struct Input {
        let emailText = CurrentValueSubject<String, Never>("")
        let passwordText = CurrentValueSubject<String, Never>("")
        let signInBtnTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let loginSuccess: PassthroughSubject<Void, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    @Published
    var input = Input()
    
    func transform(input: Input) -> Output {
        
        
        let loginSuccess = PassthroughSubject<Void, Never>()

        
        input.signInBtnTap
            .map { [weak self] _ in
                guard let self else { return LoginQuery(email: "", password: "")}
                return LoginQuery(email: input.emailText.value, password: input.passwordText.value)
            }
            .flatMap{ loginQuery in
                // combine의 Future(퍼블리셔)를 사용하여
                // 하나의 값 or 에러를 방출
                Future<AuthModel, Error> { query in
                    Task {
                        do {
                            let result = try await NetworkManager2.shared.performRequest(router: .login(query: loginQuery), responseType: AuthModel.self)
                            query(.success(result))
                        } catch {
                            query(.failure(error))
                        }
                    }
                }
            }
        // 에러인 경우, 값인 경우에 대한 결과처리 진행
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let failure):
                    print("실패", failure)
                }
            }, receiveValue: { authmodel in
                print("로그인 성공이요~~~~~~~~")
                loginSuccess.send(())
            })
            .store(in: &cancellables)
        
        
        
        return Output(loginSuccess: loginSuccess)
    }
}



extension SignInVM {
    
    private func saveUserInfo(success: AuthModel) {
        UserDefaultManager.accessToken = success.accessToken
        UserDefaultManager.refreshToken = success.refreshToken
        UserDefaultManager.userId = success.user_id
        UserDefaultManager.userNickname = success.nick
        UserDefaultManager.userEmail = success.email
    }
    
}
