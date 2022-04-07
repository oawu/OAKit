//
//  VC.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import OAKit

enum VC {
    
}

extension UIColor {
    public static let label:                            UIColor = { if #available(iOS 13, *) { return .label                            } else { return rgba(0, 0, 0, 1) } }()
    public static let secondaryLabel:                   UIColor = { if #available(iOS 13, *) { return .secondaryLabel                   } else { return rgba(60, 60, 67, 0.6) } }()
    public static let tertiaryLabel:                    UIColor = { if #available(iOS 13, *) { return .tertiaryLabel                    } else { return rgba(60, 60, 67, 0.3) } }()
    public static let quaternaryLabel:                  UIColor = { if #available(iOS 13, *) { return .quaternaryLabel                  } else { return rgba(60, 60, 67, 0.18) } }()
    public static let systemFill:                       UIColor = { if #available(iOS 13, *) { return .systemFill                       } else { return rgba(120, 120, 128, 0.2) } }()
    public static let secondarySystemFill:              UIColor = { if #available(iOS 13, *) { return .secondarySystemFill              } else { return rgba(120, 120, 128, 0.16) } }()
    public static let tertiarySystemFill:               UIColor = { if #available(iOS 13, *) { return .tertiarySystemFill               } else { return rgba(118, 118, 128, 0.12) } }()
    public static let quaternarySystemFill:             UIColor = { if #available(iOS 13, *) { return .quaternarySystemFill             } else { return rgba(116, 116, 128, 0.08) } }()
    public static let placeholderText:                  UIColor = { if #available(iOS 13, *) { return .placeholderText                  } else { return rgba(60, 60, 67, 0.3) } }()
    public static let systemBackground:                 UIColor = { if #available(iOS 13, *) { return .systemBackground                 } else { return rgba(255, 255, 255, 1.0) } }()
    public static let secondarySystemBackground:        UIColor = { if #available(iOS 13, *) { return .secondarySystemBackground        } else { return rgba(242, 242, 247, 1.0) } }()
    public static let tertiarySystemBackground:         UIColor = { if #available(iOS 13, *) { return .tertiarySystemBackground         } else { return rgba(255, 255, 255, 1.0) } }()
    public static let systemGroupedBackground:          UIColor = { if #available(iOS 13, *) { return .systemGroupedBackground          } else { return rgba(242, 242, 247, 1.0) } }()
    public static let secondarySystemGroupedBackground: UIColor = { if #available(iOS 13, *) { return .secondarySystemGroupedBackground } else { return rgba(255, 255, 255, 1.0) } }()
    public static let tertiarySystemGroupedBackground:  UIColor = { if #available(iOS 13, *) { return .tertiarySystemGroupedBackground  } else { return rgba(242, 242, 247, 1.0) } }()
    public static let separator:                        UIColor = { if #available(iOS 13, *) { return .separator                        } else { return rgba(60, 60, 67, 0.29) } }()
    public static let opaqueSeparator:                  UIColor = { if #available(iOS 13, *) { return .opaqueSeparator                  } else { return rgba(198, 198, 200, 1.0) } }()
    public static let link:                             UIColor = { if #available(iOS 13, *) { return .link                             } else { return rgba(0, 122, 255, 1.0) } }()
    public static let darkText:                         UIColor = { if #available(iOS 13, *) { return .darkText                         } else { return rgba(0, 0, 0, 1.0) } }()
    public static let lightText:                        UIColor = { if #available(iOS 13, *) { return .lightText                        } else { return rgba(255, 255, 255, 0.6) } }()
    public static let systemBlue:                       UIColor = { if #available(iOS 13, *) { return .systemBlue                       } else { return rgba(0, 122, 255, 1.0) } }()
    public static let systemGreen:                      UIColor = { if #available(iOS 13, *) { return .systemGreen                      } else { return rgba(52, 199, 89, 1.0) } }()
    public static let systemIndigo:                     UIColor = { if #available(iOS 13, *) { return .systemIndigo                     } else { return rgba(88, 86, 214, 1.0) } }()
    public static let systemOrange:                     UIColor = { if #available(iOS 13, *) { return .systemOrange                     } else { return rgba(255, 149, 0, 1.0) } }()
    public static let systemPink:                       UIColor = { if #available(iOS 13, *) { return .systemPink                       } else { return rgba(255, 45, 85, 1.0) } }()
    public static let systemPurple:                     UIColor = { if #available(iOS 13, *) { return .systemPurple                     } else { return rgba(175, 82, 222, 1.0) } }()
    public static let systemRed:                        UIColor = { if #available(iOS 13, *) { return .systemRed                        } else { return rgba(255, 59, 48, 1.0) } }()
    public static let systemTeal:                       UIColor = { if #available(iOS 13, *) { return .systemTeal                       } else { return rgba(90, 200, 250, 1.0) } }()
    public static let systemYellow:                     UIColor = { if #available(iOS 13, *) { return .systemYellow                     } else { return rgba(255, 204, 0, 1.0) } }()
    public static let systemGray:                       UIColor = { if #available(iOS 13, *) { return .systemGray                       } else { return rgba(142, 142, 147, 1.0) } }()
    public static let systemGray2:                      UIColor = { if #available(iOS 13, *) { return .systemGray2                      } else { return rgba(174, 174, 178, 1.0) } }()
    public static let systemGray3:                      UIColor = { if #available(iOS 13, *) { return .systemGray3                      } else { return rgba(199, 199, 204, 1.0) } }()
    public static let systemGray4:                      UIColor = { if #available(iOS 13, *) { return .systemGray4                      } else { return rgba(209, 209, 214, 1.0) } }()
    public static let systemGray5:                      UIColor = { if #available(iOS 13, *) { return .systemGray5                      } else { return rgba(229, 229, 234, 1.0) } }()
    public static let systemGray6:                      UIColor = { if #available(iOS 13, *) { return .systemGray6                      } else { return rgba(242, 242, 247, 1.0) } }()
}
