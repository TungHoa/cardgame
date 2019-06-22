//
//  CardCollectionViewCell.swift
//  CardGame
//
//  Created by Tung on 6/18/19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
   
    @IBOutlet weak var fontImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        // theo dõi thẻ đc chuyển qua
        self.card = card
        //nếu bài giống nhau sẽ đc ẩn đi
        if card.isMatched == true {
            backImageView.alpha = 0
            fontImageView.alpha = 0
            
            return
        }
        else{
            //nếu lá bài ko giống nhau, thì ko bị ẩn  
            backImageView.alpha = 1
            fontImageView.alpha = 1
        }
        fontImageView.image = UIImage(named: card.imageName)
        
        //Xác định xem thẻ ở trạng thái lật lên hay lật xuống
        if card.isFlipped == true {
        // đảm bảo frontimageview ở mặt trên
            UIView.transition(from: backImageView, to: fontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else{
         //đảm bảo backimageview ở mặt trên
            UIView.transition(from: fontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, . showHideTransitionViews], completion: nil)
            
            
        }
    }
    
    func flip(){
        UIView.transition(from: backImageView, to: fontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 ) {
        
        UIView.transition(from: self.fontImageView, to: self.backImageView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove(){
        //ẩn bài
        backImageView.alpha = 0
        
        //animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.fontImageView.alpha = 0
        },completion: nil )
        
    }
}
