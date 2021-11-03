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
                VStack(alignment: .leading) {
                    Text(VectorL10n.pollCreationDialogPollQuestionOrTopic)
                        .font(theme.fonts.title3)
                        .foregroundColor(theme.colors.primaryContent)
                        .padding(.top, 16.0)
                        .padding(.bottom, 8.0)
                    Text(VectorL10n.pollCreationDialogQuestionOrTopic)
                        .font(theme.fonts.subheadline)
                        .foregroundColor(theme.colors.primaryContent)
                    TextField(VectorL10n.pollCreationDialogInputPlaceholder, text: $viewModel.question.text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(VectorL10n.pollCreationDialogCreateOptions)
                        .font(theme.fonts.title3)
                        .foregroundColor(theme.colors.primaryContent)
                        .padding(.top, 16.0)
                        .padding(.bottom, 8.0)
                    ForEach(0..<viewModel.answerOptions.count, id: \.self) { index in
                        Safe($viewModel.answerOptions, index: index) { binding in
                            AnswerOptionGroup(binding: binding.text, index: index) {
                                viewModel.send(viewAction: .deleteAnswerOption(viewModel.answerOptions[index]))
                            }
                        }
                    }
                    Button(VectorL10n.pollCreationDialogAddOption, action: {
                        viewModel.send(viewAction: .addAnswerOption)
                    })
                    .padding([.top, .bottom])
                    .disabled(viewModel.viewState.addAnswerOptionButtonEnabled == false)
                    Spacer()
                    PrimaryActionButton(confirmationButtonEnabled: viewModel.viewState.confirmationButtonEnabled)
                }
                .padding()
                .modifier(NavigationTitleBar(titleColor: theme.colors.primaryContent) {
                    print("Cancelled")
                })
            }
        }
        .accentColor(theme.colors.accent)
    }
}

@available(iOS 14.0, *)
private struct PrimaryActionButton: View {
    @Environment(\.theme) private var theme: ThemeSwiftUI
    var confirmationButtonEnabled: Bool
    
    var body: some View {
        Button(VectorL10n.pollCreationDialogCreatePoll, action: {
            print("Create poll")
        })
        .disabled(confirmationButtonEnabled == false)
        .padding(12.0)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .font(theme.fonts.body)
        .background(theme.colors.accent)
        .opacity(confirmationButtonEnabled == true ? 1.0 : 0.6)
        .cornerRadius(8.0)
    }
}

@available(iOS 14.0, *)
private struct AnswerOptionGroup: View {
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    var binding: Binding<String>
    
    let index: Int
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(VectorL10n.pollCreationDialogOptionNumber(index + 1))
                .font(theme.fonts.subheadline)
                .foregroundColor(theme.colors.primaryContent)
            HStack {
                TextField(VectorL10n.pollCreationDialogInputPlaceholder, text: binding)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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

/**
 Used to avoid crashes when enumerating through bindings in the AnswerOptions ForEach
 https://stackoverflow.com/q/65375372
 Replace with Swift 5.5 bindings enumerator later.
 */
@available(iOS 14.0, *)
private struct Safe<T: RandomAccessCollection & MutableCollection, C: View>: View {
    
    typealias BoundElement = Binding<T.Element>
    private let binding: BoundElement
    private let content: (BoundElement) -> C
    
    init(_ binding: Binding<T>, index: T.Index, @ViewBuilder content: @escaping (BoundElement) -> C) {
        self.content = content
        self.binding = .init(get: { binding.wrappedValue[index] },
                             set: { binding.wrappedValue[index] = $0 })
    }
    
    var body: some View {
        content(binding)
    }
}
