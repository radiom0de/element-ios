// File created from SimpleUserProfileExample
// $ createScreen.sh Room/PollEditForm PollEditForm
/*
 Copyright 2021 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import UIKit
import SwiftUI

final class PollEditFormCoordinator: Coordinator {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let parameters: PollEditFormCoordinatorParameters
    private let pollEditFormHostingController: UIViewController
    private var pollEditFormViewModel: PollEditFormViewModelProtocol
    
    // MARK: Public

    // Must be used only internally
    var childCoordinators: [Coordinator] = []
    var completion: (() -> Void)?
    
    // MARK: - Setup
    
    @available(iOS 14.0, *)
    init(parameters: PollEditFormCoordinatorParameters) {
        self.parameters = parameters
        let viewModel = PollEditFormViewModel.makePollEditFormViewModel(pollEditFormService: PollEditFormService(session: parameters.session))
        let view = PollEditForm(viewModel: viewModel.context)
            .addDependency(AvatarService.instantiate(mediaManager: parameters.session.mediaManager))
        pollEditFormViewModel = viewModel
        pollEditFormHostingController = VectorHostingController(rootView: view)
    }
    
    // MARK: - Public
    func start() {
        MXLog.debug("[PollEditFormCoordinator] did start.")
        pollEditFormViewModel.completion = { [weak self] result in
            MXLog.debug("[PollEditFormCoordinator] PollEditFormViewModel did complete with result: \(result).")
            guard let self = self else { return }
            switch result {
            case .cancel, .done:
                self.completion?()
            }
        }
    }
    
    func toPresentable() -> UIViewController {
        return self.pollEditFormHostingController
    }
}
