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
import Reusable

class SpaceMenuListViewCell: UITableViewCell, SpaceMenuCell, NibReusable {
    
    // MARK: - Properties
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var selectionView: UIView!

    // MARK: - Private
    
    private var theme: Theme?
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        self.selectionView.layer.cornerRadius = 8.0
        self.selectionView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.selectionView.alpha = selected ? 1.0 : 0.0
        }
    }

    // MARK: - Public
    
    func update(with viewData: SpaceMenuListItemViewData) {
        self.iconView.image = viewData.icon
        self.titleLabel.text = viewData.title
        
        guard let theme = self.theme else {
            return
        }
        
        if viewData.style == .destructive {
            self.titleLabel.textColor = theme.colors.alert
            self.iconView.tintColor = theme.colors.alert
        } else {
            self.titleLabel.textColor = theme.colors.primaryContent
            self.iconView.tintColor = theme.colors.secondaryContent
        }
    }
    
    func update(theme: Theme) {
        self.theme = theme
        self.backgroundColor = theme.colors.background
        self.iconView.tintColor = theme.colors.secondaryContent
        self.titleLabel.textColor = theme.colors.primaryContent
        self.titleLabel.font = theme.fonts.body
        self.selectionView.backgroundColor = theme.colors.separator
    }
}
