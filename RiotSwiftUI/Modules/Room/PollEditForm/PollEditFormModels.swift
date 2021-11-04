// File created from SimpleUserProfileExample
// $ createScreen.sh Room/PollEditForm PollEditForm
// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import SwiftUI

@available(iOS 14, *)
enum PollEditFormStateAction {
    case viewAction(PollEditFormViewAction)
}

@available(iOS 14, *)
enum PollEditFormViewAction {
    case addAnswerOption
    case deleteAnswerOption(PollEditFormAnswerOption)
    case cancel
    case create
}

@available(iOS 14, *)
enum PollEditFormViewModelResult {
    case cancel
    case create(String, [String])
}

@available(iOS 14, *)
struct PollEditFormQuestion {
    var text: String {
        didSet {
            text = String(text.prefix(maxLength))
        }
    }
    
    let maxLength: Int
}

@available(iOS 14, *)
struct PollEditFormAnswerOption: Identifiable, Equatable {
    let id = UUID()

    var text: String {
        didSet {
            text = String(text.prefix(maxLength))
        }
    }
    
    let maxLength: Int
}

@available(iOS 14, *)
struct PollEditFormViewState: BindableState {
    let maxAnswerOptionsCount: Int
    var bindings: PollEditFormViewStateBindings
    
    var confirmationButtonEnabled: Bool {
        !bindings.question.text.isEmpty && bindings.answerOptions.filter({ $0.text.isEmpty }).count == 0
    }
    
    var addAnswerOptionButtonEnabled: Bool {
        bindings.answerOptions.count < maxAnswerOptionsCount
    }
}

@available(iOS 14, *)
struct PollEditFormViewStateBindings {
    var question: PollEditFormQuestion
    var answerOptions: [PollEditFormAnswerOption]
}
