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
    public static func label()                            -> UIColor { if #available(iOS 13, *) { return .label                            } else { return rgba(0, 0, 0, 1) } }
    public static func secondaryLabel()                   -> UIColor { if #available(iOS 13, *) { return .secondaryLabel                   } else { return rgba(60, 60, 67, 0.6) } }
    public static func tertiaryLabel()                    -> UIColor { if #available(iOS 13, *) { return .tertiaryLabel                    } else { return rgba(60, 60, 67, 0.3) } }
    public static func quaternaryLabel()                  -> UIColor { if #available(iOS 13, *) { return .quaternaryLabel                  } else { return rgba(60, 60, 67, 0.18) } }
    public static func systemFill()                       -> UIColor { if #available(iOS 13, *) { return .systemFill                       } else { return rgba(120, 120, 128, 0.2) } }
    public static func secondarySystemFill()              -> UIColor { if #available(iOS 13, *) { return .secondarySystemFill              } else { return rgba(120, 120, 128, 0.16) } }
    public static func tertiarySystemFill()               -> UIColor { if #available(iOS 13, *) { return .tertiarySystemFill               } else { return rgba(118, 118, 128, 0.12) } }
    public static func quaternarySystemFill()             -> UIColor { if #available(iOS 13, *) { return .quaternarySystemFill             } else { return rgba(116, 116, 128, 0.08) } }
    public static func placeholderText()                  -> UIColor { if #available(iOS 13, *) { return .placeholderText                  } else { return rgba(60, 60, 67, 0.3) } }
    public static func systemBackground()                 -> UIColor { if #available(iOS 13, *) { return .systemBackground                 } else { return rgba(255, 255, 255, 1.0) } }
    public static func secondarySystemBackground()        -> UIColor { if #available(iOS 13, *) { return .secondarySystemBackground        } else { return rgba(242, 242, 247, 1.0) } }
    public static func tertiarySystemBackground()         -> UIColor { if #available(iOS 13, *) { return .tertiarySystemBackground         } else { return rgba(255, 255, 255, 1.0) } }
    public static func systemGroupedBackground()          -> UIColor { if #available(iOS 13, *) { return .systemGroupedBackground          } else { return rgba(242, 242, 247, 1.0) } }
    public static func secondarySystemGroupedBackground() -> UIColor { if #available(iOS 13, *) { return .secondarySystemGroupedBackground } else { return rgba(255, 255, 255, 1.0) } }
    public static func tertiarySystemGroupedBackground()  -> UIColor { if #available(iOS 13, *) { return .tertiarySystemGroupedBackground  } else { return rgba(242, 242, 247, 1.0) } }
    public static func separator()                        -> UIColor { if #available(iOS 13, *) { return .separator                        } else { return rgba(60, 60, 67, 0.29) } }
    public static func opaqueSeparator()                  -> UIColor { if #available(iOS 13, *) { return .opaqueSeparator                  } else { return rgba(198, 198, 200, 1.0) } }
    public static func link()                             -> UIColor { if #available(iOS 13, *) { return .link                             } else { return rgba(0, 122, 255, 1.0) } }
    public static func darkText()                         -> UIColor { if #available(iOS 13, *) { return .darkText                         } else { return rgba(0, 0, 0, 1.0) } }
    public static func lightText()                        -> UIColor { if #available(iOS 13, *) { return .lightText                        } else { return rgba(255, 255, 255, 0.6) } }
    public static func systemBlue()                       -> UIColor { if #available(iOS 13, *) { return .systemBlue                       } else { return rgba(0, 122, 255, 1.0) } }
    public static func systemGreen()                      -> UIColor { if #available(iOS 13, *) { return .systemGreen                      } else { return rgba(52, 199, 89, 1.0) } }
    public static func systemIndigo()                     -> UIColor { if #available(iOS 13, *) { return .systemIndigo                     } else { return rgba(88, 86, 214, 1.0) } }
    public static func systemOrange()                     -> UIColor { if #available(iOS 13, *) { return .systemOrange                     } else { return rgba(255, 149, 0, 1.0) } }
    public static func systemPink()                       -> UIColor { if #available(iOS 13, *) { return .systemPink                       } else { return rgba(255, 45, 85, 1.0) } }
    public static func systemPurple()                     -> UIColor { if #available(iOS 13, *) { return .systemPurple                     } else { return rgba(175, 82, 222, 1.0) } }
    public static func systemRed()                        -> UIColor { if #available(iOS 13, *) { return .systemRed                        } else { return rgba(255, 59, 48, 1.0) } }
    public static func systemTeal()                       -> UIColor { if #available(iOS 13, *) { return .systemTeal                       } else { return rgba(90, 200, 250, 1.0) } }
    public static func systemYellow()                     -> UIColor { if #available(iOS 13, *) { return .systemYellow                     } else { return rgba(255, 204, 0, 1.0) } }
    public static func systemGray()                       -> UIColor { if #available(iOS 13, *) { return .systemGray                       } else { return rgba(142, 142, 147, 1.0) } }
    public static func systemGray2()                      -> UIColor { if #available(iOS 13, *) { return .systemGray2                      } else { return rgba(174, 174, 178, 1.0) } }
    public static func systemGray3()                      -> UIColor { if #available(iOS 13, *) { return .systemGray3                      } else { return rgba(199, 199, 204, 1.0) } }
    public static func systemGray4()                      -> UIColor { if #available(iOS 13, *) { return .systemGray4                      } else { return rgba(209, 209, 214, 1.0) } }
    public static func systemGray5()                      -> UIColor { if #available(iOS 13, *) { return .systemGray5                      } else { return rgba(229, 229, 234, 1.0) } }
    public static func systemGray6()                      -> UIColor { if #available(iOS 13, *) { return .systemGray6                      } else { return rgba(242, 242, 247, 1.0) } }
}
