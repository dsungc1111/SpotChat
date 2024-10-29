//
//  LoginReactor.swift
//  SpotChat
//
//  Created by 최대성 on 10/27/24.
//


import ReactorKit
import RxSwift

final class LoginReactor: Reactor {
   
    // 사용자 이벤트
    enum Action {
        case updateEmail(String)
        case updatePassword(String)
        case login
    }
    
    // 처리 단위
    enum Mutation {
        case setEmail(String)
        case setPassword(String)
        case loginBtnTapped(String)
        case btnEnabled(Bool)
    }
    
    // 현재 상태 기록
    struct State {
        var email: String = ""
        var password: String = ""
        var btnEnable = false
        var loginResult = ""
    }
    
    let initialState = State()
    
    // 액션이 들어왔을 때, 어떤 처리를 할건지?
    // action과 state의 중간다리, 뷰에 노출되지 않도록!
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateEmail(email):
            let isValid = isValidEmail(email) && isValidPassword(currentState.password)
            print("아이디")
            return Observable.concat([
                .just(.setEmail(email)),
                .just(.btnEnabled(isValid))
            ])
        case let .updatePassword(password):
            let isValid = isValidEmail(currentState.email) && isValidPassword(password)
            print("비밀번호")
            return Observable.concat([
                .just(.setPassword(password)),
                .just(.btnEnabled(isValid))
            ])
        case .login:
            let result = currentState.email.isEmpty ? "이메일 없어용" : currentState.email
            return .just(.loginBtnTapped(result))
        }
    }
    
    // 이전 상태처리(newState = state)를 받아서
    // 다음 상태로 반환하는 함수 switch 문으로 상태 변경 해준 후 newState 반환
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setEmail(email):
            newState.email = email
        case let .loginBtnTapped(result):
            newState.loginResult = result
        case let .setPassword(password):
            newState.password = password
        case let .btnEnabled(btnEnable):
            newState.btnEnable = btnEnable
        }
        
        
        return newState
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}


/*
 또
 */
