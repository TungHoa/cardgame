//
//  ViewController.swift
//  CardGame
//
//  Created by Tung on 6/18/19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer!
    var seconds:Int =  30 // second
    
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        //Gọi hàm getCards của class CardModel
       cardArray = model.getCards()
        
        //truy cập delegate và gán view controller có thể sử dụng, 
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create timer
        timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeRemain), userInfo: nil, repeats: true)
       RunLoop.main.add(timer, forMode: .common)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        soundManager.playSound(.shuffle)
    }
    
    //Time methor
    @objc func timeRemain(){
        seconds -= 1
 
        // set label
        timeLabel.text = "Time Remainning: \(seconds)"
        
        //khi time về 0
        if seconds  == 0{
            
            //stop the timer
            timer.invalidate()
            timeLabel.textColor = UIColor.red
            
            //kiểm tra bài chưa đc ghép
            checkGameEnded()
        }
    }

    //Mark: UICollection protocol methor
    
    //số lượng trong phần đc chỉ định
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    //cell tương ứng với phần đc chỉ định
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Lấy 1 đối tượng CardCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Lấy lá bài mà collection view đang hiện  
        let card = cardArray[indexPath.row]
        
        // đặt bài cho ô đó
        cell.setCard(card)
        return cell
    }
    //item đã đc chọn
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
  
        // Lấy ô mà ng dùng chọn
        let cell = collectionView.cellForItem(at: indexPath) as!CardCollectionViewCell
        
        // Lấy lá bài ng dùng chọn
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            //lật mặt
            cell.flip()
            
        //play the flip sound
            soundManager.playSound(.flip)
            
            //đặt trạng thái cho lá bài
            card.isFlipped = true
            
            //xác định xem đó là lá bài thứ nhất hay thứ hai đc lật
            if firstFlippedCardIndex == nil{
                
                //đây là lá bài đầu tiên đc lật
                firstFlippedCardIndex = indexPath
            }
            else{
                //đây là lá bài thứ 2 đc lật
                
                // thực hiện logic 
                checkForMatches(indexPath)
            }
            
        }
//        else{
//            //lật lá bài lại
//            cell.flipBack()
//
//            //đặt trạng thái cho lá bài
//            card.isFlipped = false
//        }
        
    }//end the didselectItemAt methor
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        //Lấy cells cho 2 lá bài đã được tiết lộ
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //lấy bài cho 2 lá bài đã được tiết lộ
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //So sánh 2 lá bài
        if cardOne.imageName == cardTwo.imageName {
            
            //2 lá bài giống nhau
            
            //play sound
            soundManager.playSound(.match)
            
            //đặt trạng thái cho lá bài
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //loại bỏ bài khỏi bộ bài
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //kiểm tra bài còn lại
            checkGameEnded()
        }
        else {
            //2 lá bài ko giống nhau
            
            //play sound
            soundManager.playSound(.nomatch)
            
            //đặt trạng thái cho lá bài
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //lật cả 2 lá bài lại
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        // bảo với collection view load lại ô của lá bài đầu tiên nếu nó nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //khởi đôngj lại thuộc tính đánh dấu lá bài đầu tiên đc lật
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        //xác định xen thẻ nào chưa ghép
        var isWon = true
        for card in cardArray{
            if card.isMatched == false{
                isWon = false
                break
            }
            
        }
       
        var title = ""
        var message = ""
        //nếu ko có , ng chơi  thắng , dừng time
        if isWon == true{
            if seconds > 0 {
               timer.invalidate()
            }
            title = "Congratulations"
            message = "You win"
        }

        //nếu có bài chưa ghép  , kiểm tra còn lại bao nhieu thời gian
        else{
            if seconds > 0 {
                return
            }
            title = " Game over"
            message = "You lose"
        }
        //hiện thị tin nhắn win/lose
        
        showAlert(title, message)
        
    }
    func showAlert(_ title:String, _ message:String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}//end viewcontroller class

