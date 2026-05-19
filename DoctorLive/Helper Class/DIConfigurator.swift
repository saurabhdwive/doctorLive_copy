//
//  DIConfigurator.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import Foundation
import UIKit

let KEY_WINDOW = UIApplication.shared.windows


class DIConfigurator {
    
    private static let sharedOjbect = DIConfigurator()
    
    class func sharedInst() -> DIConfigurator {
        return sharedOjbect
    }
    
    // Method for get View Controller
    func getViewControler(_ storyBoard: StoryboardType, indentifier: String) -> UIViewController {
        let storyB = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return storyB.instantiateViewController(withIdentifier: indentifier)
    }
    
    //MARK: - Tabbar
//    func getTabbarViewC() -> TabbarViewC {
//        let tabbarViewC = self.getViewControler(.Tabbar, indentifier: TabbarViewC.className) as! TabbarViewC
//        return tabbarViewC
//    }
    
    
    //MARK: - SIDE MENU
    
    func getFeesDetailViewC() -> FeesDetailViewC {
          let feesDetailViewC = self.getViewControler(.Auth, indentifier: FeesDetailViewC.className) as! FeesDetailViewC
          return feesDetailViewC
      }
    
    func getVideoCallViewC() -> VideoCallViewC {
          let videoCallViewC = self.getViewControler(.VideoFlow, indentifier: VideoCallViewC.className) as! VideoCallViewC
          return videoCallViewC
      }
    
 
    //QUESTION
    
    func getMyArticleViewC() -> MyArticleViewC {
          let myArticleViewC = self.getViewControler(.Question, indentifier: MyArticleViewC.className) as! MyArticleViewC
          return myArticleViewC
      }
    
    func getWriteArticleViewC() -> WriteArticleViewC {
          let writeArticleViewC = self.getViewControler(.Question, indentifier: WriteArticleViewC.className) as! WriteArticleViewC
          return writeArticleViewC
      }
    
    func getQuestionListViewC() -> QuestionListViewC {
          let questionListViewC = self.getViewControler(.Question, indentifier: QuestionListViewC.className) as! QuestionListViewC
          return questionListViewC
      }
    
    func getMyAnswerViewC() -> MyAnswerViewC {
          let myAnswerViewC = self.getViewControler(.Question, indentifier: MyAnswerViewC.className) as! MyAnswerViewC
          return myAnswerViewC
      }
    
    func getAnswerAddEditViewC() -> AnswerAddEditViewC {
          let answerAddEditViewC = self.getViewControler(.Question, indentifier: AnswerAddEditViewC.className) as! AnswerAddEditViewC
          return answerAddEditViewC
      }
    
    func getQuestionDetailViewC() -> QuestionDetailViewC {
          let questionDetailViewC = self.getViewControler(.Question, indentifier: QuestionDetailViewC.className) as! QuestionDetailViewC
          return questionDetailViewC
      }
    
    
    func getChatViewC() -> ChatViewC {
          let chatViewC = self.getViewControler(.Auth, indentifier: ChatViewC.className) as! ChatViewC
          return chatViewC
      }
    
    func getImagePopPrieViewC() -> ImagePopPrieViewC {
          let imagePopPrieViewC = self.getViewControler(.Auth, indentifier: ImagePopPrieViewC.className) as! ImagePopPrieViewC
          return imagePopPrieViewC
      }
    
    
    func getLoginViewC() -> LoginVC {
          let loginViewC = self.getViewControler(.Auth, indentifier: LoginVC.className) as! LoginVC
          return loginViewC
      }
    
    

    
    //method to make Root Controller
    func getRootViewC(_ storyBoard: StoryboardType, identifer:String) {
        let viewC = getViewControler(storyBoard, indentifier: identifer)
        let navigationController = UINavigationController(rootViewController: viewC)
        KEY_WINDOW.first?.rootViewController = navigationController
        KEY_WINDOW.first?.makeKeyAndVisible()
    }
    func setVideoCallAsRoot(viewC: UIViewController) {
        let nav = UINavigationController(rootViewController: viewC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
            DispatchQueue.main.async {
                nav.view.layoutIfNeeded()
                viewC.view.layoutIfNeeded()
            }
        }
    }
}



enum StoryboardType: String {
    
    case Auth
    case VideoFlow
    case Question
    
    var storyboardName: String {
        return rawValue
    }
}
