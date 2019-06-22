//
//  CardModel.swift
//  CardGame
//
//  Created by Tung on 6/18/19.
//  Copyright © 2019 Tung. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        //khai báo 1 mảng chứa các lá bài
        var generatedCardArray = [Card]()
        
        //Tạo ra ngẫu nhiên 1 cặp bài
        for _ in 1...3 {
            //Lấy 1 số ngẫu nhiên
            //let randomNumber = arc4random_uniform(4) + 1
            let randomNumber = Int.random(in: 1...4)
            
            print(randomNumber)
            //Tạo 1 đối tượng bài đầu tiên
            
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            //thêm bài đc tạo ra
            generatedCardArray.append(cardOne)
            
            //Tạo đối tượng card thứ 2
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"

            generatedCardArray.append(cardTwo)
        }
        //TODO: Chọn ngẫu nhiên mảng
        print(generatedCardArray.count)
        generatedCardArray.shuffle()
        //Trả về mảng
        return generatedCardArray
    }
}
