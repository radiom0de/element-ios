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

import SwiftUI

@available(iOS 14.0, *)
struct PollEditForm: View {
    
    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    // MARK: Public
    
    @ObservedObject var viewModel: PollEditFormViewModel.Context
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16.0) {
                    Text(VectorL10n.pollCreationDialogPollQuestionOrTopic)
                        .font(theme.fonts.title3)
                        .foregroundColor(theme.colors.primaryContent)
                    
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(VectorL10n.pollCreationDialogQuestionOrTopic)
                            .font(theme.fonts.subheadline)
                            .foregroundColor(theme.colors.primaryContent)
                        
                        MultilineTextField(VectorL10n.pollCreationDialogInputPlaceholder, text: $viewModel.question.text)
                    }
                    
                    Text(VectorL10n.pollCreationDialogCreateOptions)
                        .font(theme.fonts.title3)
                        .foregroundColor(theme.colors.primaryContent)
                    
                    ForEach(0..<viewModel.answerOptions.count, id: \.self) { index in
                        SafeBindingCollectionEnumerator($viewModel.answerOptions, index: index) { binding in
                            AnswerOptionGroup(binding: binding.text, index: index) {
                                viewModel.send(viewAction: .deleteAnswerOption(viewModel.answerOptions[index]))
                            }
                        }
                    }
                    
                    Button(VectorL10n.pollCreationDialogAddOption) {
                        viewModel.send(viewAction: .addAnswerOption)
                    }
                    .disabled(!viewModel.viewState.addAnswerOptionButtonEnabled)
                    
                    Spacer()
                    
                    Button(VectorL10n.pollCreationDialogCreatePoll) {
                        viewModel.send(viewAction: .create)
                    }
                    .buttonStyle(PrimaryActionButtonStyle(enabled: viewModel.viewState.confirmationButtonEnabled))
                    .disabled(!viewModel.viewState.confirmationButtonEnabled)
                }
                .animation(.easeOut(duration: 0.1))
                .padding()
                .modifier(NavigationTitleBar(titleColor: theme.colors.primaryContent) {
                    viewModel.send(viewAction: .cancel)
                })
            }
        }
        .accentColor(theme.colors.accent)
    }
}

@available(iOS 14.0, *)
private struct AnswerOptionGroup: View {
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    @State private var focused = false
    
    var binding: Binding<String>
    
    let index: Int
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(VectorL10n.pollCreationDialogOptionNumber(index + 1))
                .font(theme.fonts.subheadline)
                .foregroundColor(theme.colors.primaryContent)
            
            HStack(spacing: 16.0) {
                TextField(VectorL10n.pollCreationDialogInputPlaceholder, text: binding, onEditingChanged: { edit in
                    self.focused = edit
                })
                .textFieldStyle(BorderedInputFieldStyle(theme: _theme, isEditing: focused))
                Button {
                    onDelete()
                } label: {
                    Image(uiImage:Asset.Images.pollDeleteOptionIcon.image)
                }
            }
        }
    }
}

@available(iOS 14.0, *)
private struct NavigationTitleBar: ViewModifier {
    let titleColor: Color
    let cancelCallback: () -> Void
    
    func body(content: Content) -> some View {
        return content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(VectorL10n.cancel, action: {
                        cancelCallback()
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text(VectorL10n.pollCreationDialogCreatePoll)
                        .font(.headline)
                        .foregroundColor(titleColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews

@available(iOS 14.0, *)
struct PollEditForm_Previews: PreviewProvider {
    static let stateRenderer = MockPollEditFormScreenState.stateRenderer
    static var previews: some View {
        stateRenderer.screenGroup()
    }
}
