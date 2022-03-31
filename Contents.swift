//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyStockController: UIViewController {
    var test1: UILabel = UILabel()
    var calculateTypeLabel: UILabel = UILabel()
    var buyContainHandPriceTypeLbale: UILabel = UILabel()
    var buyPriceLabel: UILabel = UILabel()
    var handPriceDiscountLabel: UILabel = UILabel()
    var profitLabel: UILabel = UILabel()
    var lowestPriceLabel: UILabel = UILabel()
    var lowestNetLabel: UILabel = UILabel()
    var netIncomePriceLabel: UILabel = UILabel()
    var netIncomeLabel: UILabel = UILabel()
    var oldNumberOfSheetsLabel: UILabel = UILabel()
    var newNumberOfSheetsLabel: UILabel = UILabel()
    var highestRisePercentageLabel: UILabel = UILabel()
        
    var calculateTypeTextField: UITextField = UITextField()             // 是否為當沖
    var buyContainHandPriceTextField: UITextField = UITextField()       // 是否包含手續費
    var buyPriceTextField: UITextField = UITextField()                  // 買入價格
    var handPriceDiscountTextField: UITextField = UITextField()         // 手續費折數
    var profitTextField: UITextField = UITextField()                    // 期望獲利
    var oldNumberOfSheetsTextField: UITextField = UITextField()
    var newNumberOfSheetsTextField: UITextField = UITextField()
    var highestRisePercentageTextField: UITextField = UITextField()
    
    var calculateButton: UIButton = UIButton(type: .system)
        
    var calculateType: Bool = false
    var buyContainHandPrice: Bool = false
    var transactionTaxPercent: Float = 0.3
    var buyPrice: Float = 0.0
    var handPriceDiscount: Float = 1.0
    var profit: Float = 0.0
    var stockUnit: Double = 0.01
    
    var oldNumberOfSheets: Int = 0
    var newNumberOfSheets: Int = 0
    var highestRisePercentage: Float = 0.1
    
    var share: Int = 1000
    var buyPriceShare: Float = 0.0
    var buyPriceRoundShare: Float = 0.0
    var buyPriceCost: Float = 0.0
    
    /*
     (A * 1000 * N + (x * 1000 * n) + ((x * 1.425) * n) + (((x + xy) * 1.425) * n) + (((x + xy) * 0.3) * n)) / (N + n) <= ((x + xy) * 1000)
     1000AN + 1000xn + 1.425xn + 1.425xn + 1.425xyn + 0.3xn + 0.3xyn <= 1000(N + n)(x + xy)
     1000AN + 1000xn + 2 * 1.425xn + 0.3xn + 1.425xyn + 0.3xyn <= 1000xN + 1000xyN + 1000xn + 1000xyn
     1000AN <= 1000xN + 1000xyN + 1000xn + 1000xyn - (1000xn + 2 * 1.425xn + 0.3xn + 1.425xyn + 0.3xyn)
     1000AN <= x (1000N + 1000yN + 1000n + 1000yn - 1000n - 2 * 1.425n - 0.3n - 1.425yn - 0.3yn)
     
     */

    @objc func calculateFunc() {
        if let t = calculateTypeTextField.text {
            if t == "Yes" {
                calculateType = true
                transactionTaxPercent = 0.15
            }
            else {
                calculateType = false
                transactionTaxPercent = 0.3
            }
        }
        
        if let t = buyContainHandPriceTextField.text {
            if t == "Yes" {
                buyContainHandPrice = true
            }
            else {
                buyContainHandPrice = false
            }
        }
        
        if let t = buyPriceTextField.text {
            buyPrice = (t as NSString).floatValue
        }
        
        if buyPrice < 10.0 {
            stockUnit = 0.01
        }
        else if buyPrice >= 10.0 && buyPrice < 50.0 {
            stockUnit = 0.05
        }
        else if buyPrice >= 50.0 && buyPrice < 100.0 {
            stockUnit = 0.1
        }
        else {
            stockUnit = 0.5
        }
        
        if let t = handPriceDiscountTextField.text {
            handPriceDiscount = (t as NSString).floatValue
        }
        
        if let t = profitTextField.text {
            profit = (t as NSString).floatValue
        }
        
        if let t = oldNumberOfSheetsTextField.text {
            oldNumberOfSheets = (t as NSString).integerValue
        }
        
        if let t = newNumberOfSheetsTextField.text {
            newNumberOfSheets = (t as NSString).integerValue
        }
        
        if let t = highestRisePercentageTextField.text {
            highestRisePercentage = (t as NSString).floatValue
        }
        
        buyPriceShare = buyPrice * Float(share)
        
        let temp: Float = buyPriceShare / Float(share) / 0.01
        buyPriceRoundShare = temp * Float(share) * 0.01
        
        print("\(buyPriceShare)")
        print("\(buyPriceRoundShare)")
        
        var output1: Float = 0.0
        var output2: Float = 0.0
        var result: Float = 0.0
        var firstFlag: Bool = false
        var lowestPrice: Float = 0.0
        var lowestNet: Float = 0.0
        
        var lowestNetInt: Int = 0
        var netIncomeInt: Int = 0
        
        
        if buyContainHandPrice == false {
            var handPrice: Float = (buyPriceShare * 0.1425 / 100) * handPriceDiscount
            if handPrice < 20 {
                handPrice = 20
            }
            
            buyPriceCost = buyPriceShare + handPrice
        }
        else {
            buyPriceCost = buyPriceShare
        }
        
        print("\(buyPriceCost)")
        
        
        //1000AN <= x (1000N + 1000yN + 1000n + 1000yn - 1000n + 2 * 1.425n + 0.3n + 1.425yn + 0.3yn)
        let N: Float = Float(oldNumberOfSheets)
        let n: Float = Float(newNumberOfSheets)
        let s: Float = Float(share)
        let y: Float = Float(highestRisePercentage)
        var x: Float = (buyPriceCost * N) / (s * N + s * y * N + s * n + s * y * n - s * n - 2 * 1.425 * n - 0.3 * n - 1.425 * y * n - 0.3 * y * n)
        
        print("=====\(x)")
        
        var sum: Float = buyPrice
        for i in stride(from: 0.0, to: 1000.0, by: stockUnit) {
            let index: Float = Float(i)
            sum = buyPrice + index
    
            print("\(index)")
            if ((sum - buyPrice) / buyPrice) >= 0.1 {
                break
            }
            else {
                print("\((sum - buyPrice) / buyPrice)")
                print("\(Float(sum))")
            }
        }
        
        for i in stride(from: 0.0, to: 1000.0, by: stockUnit) {
            let index: Float = Float(i)
            result = buyPriceRoundShare + (Float(share) * index)
            output1 = ((result * 0.1425) / 100) * handPriceDiscount
            if (output1 < 20) {
                output1 = 20
            }
            
            output2 = ((result * transactionTaxPercent) / 100)
            
            if ((result - (buyPriceCost + output1 + output2)) > profit) {
                if firstFlag == false {
                    firstFlag = true
                    lowestPrice = result / Float(share)
                    lowestNet = result - buyPriceCost - output1 - output2
                    print("|***********************************************************************|");
                    print("|=======================================================================|");
                }
                print("|增加：\((result / Float(share))), 賣出價格：\(result) > 賣出總成本：\((buyPriceCost + output1 + output2))")
                break
            }
            else if ((result - (buyPriceCost + output1 + output2)) > 0) {
                if firstFlag == false {
                    firstFlag = true
                    lowestPrice = result / Float(share)
                    lowestNet = result - buyPriceCost - output1 - output2
                    print("|***********************************************************************|");
                    print("|=======================================================================|");
                }
                print("|增加：\((result / Float(share))), 賣出價格：\(result) > 賣出總成本：\((buyPriceCost + output1 + output2))")
            }
            else {
                print("|增加：\((result / Float(share))), 賣出價格：\(result) < 賣出總成本：\((buyPriceCost + output1 + output2))")
            }
        }
        
        lowestNetInt = lroundf(lowestNet)
        netIncomeInt = lroundf(result - buyPriceCost - output1 - output2)
        
        print("|=======================================================================|");
        print("|-----------------------------------------------------------------------|");
        print("|                                                                       |");
        print("|最低一張賣出價格 = \(lowestPrice)");
        print("|最低淨賺 = \(lowestNetInt)");
        print("|賣出價格 = \(result / Float(share))");
        print("|淨賺 = \(netIncomeInt)");
        print("|=======================================================================|");
        print("+-----------------------------------------------------------------------+");
        
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        lowestPriceLabel.text = "最低一張賣出價格：" + nf.string(for: lowestPrice)!
        lowestNetLabel.text = "最低淨賺：" + String(lowestNetInt)
        netIncomePriceLabel.text = "賣出價格：" + nf.string(for: (result / Float(share)))!
        netIncomeLabel.text = "淨賺：" + String(netIncomeInt)
    }
    
    public override func loadView() {
        let view: UIView = UIView()
        view.backgroundColor = .white
        
        calculateTypeLabel.text = "是否為當沖:"
        calculateTypeLabel.textColor = .black
        calculateTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calculateTypeLabel)
        
        calculateTypeTextField.borderStyle = .roundedRect
        calculateTypeTextField.placeholder = "輸入Yes 或 No"
        calculateTypeTextField.text = "No"
        calculateTypeTextField.keyboardType = UIKeyboardType.namePhonePad
        calculateTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calculateTypeTextField)
        
        buyContainHandPriceTypeLbale.text = "是否包含手續費:"
        buyContainHandPriceTypeLbale.textColor = .black
        buyContainHandPriceTypeLbale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyContainHandPriceTypeLbale)
        
        buyContainHandPriceTextField.borderStyle = .roundedRect
        buyContainHandPriceTextField.placeholder = "輸入Yes 或 No"
        buyContainHandPriceTextField.text = "No"
        buyContainHandPriceTextField.keyboardType = UIKeyboardType.namePhonePad
        buyContainHandPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyContainHandPriceTextField)
        
        buyPriceLabel.text = "買入價格:"
        buyPriceLabel.textColor = .black
        buyPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyPriceLabel)
        
        buyPriceTextField.borderStyle = .roundedRect
        buyPriceTextField.placeholder = "輸入價格"
        buyPriceTextField.keyboardType = UIKeyboardType.namePhonePad
        buyPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyPriceTextField)
        
        handPriceDiscountLabel.text = "手續費折數:"
        handPriceDiscountLabel.textColor = .black
        handPriceDiscountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handPriceDiscountLabel)
        
        handPriceDiscountTextField.borderStyle = .roundedRect
        handPriceDiscountTextField.placeholder = "0.1 ~ 0.9"
        handPriceDiscountTextField.keyboardType = UIKeyboardType.namePhonePad
        handPriceDiscountTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handPriceDiscountTextField)
        
        profitLabel.text = "期望獲利:"
        profitLabel.textColor = .black
        profitLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profitLabel)
        
        profitTextField.borderStyle = .roundedRect
        profitTextField.placeholder = "輸入期望獲利"
        profitTextField.keyboardType = UIKeyboardType.namePhonePad
        profitTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profitTextField)
        
        calculateButton.setTitle("開始計算", for: .normal)
        calculateButton.addTarget(self, action: #selector(calculateFunc), for: .touchUpInside)
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calculateButton)
                
        lowestPriceLabel.text = ""
        lowestPriceLabel.textColor = .black
        lowestPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lowestPriceLabel)
        
        lowestNetLabel.text = ""
        lowestNetLabel.textColor = .black
        lowestNetLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lowestNetLabel)
        
        netIncomePriceLabel.text = ""
        netIncomePriceLabel.textColor = .black
        netIncomePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(netIncomePriceLabel)
        
        netIncomeLabel.text = ""
        netIncomeLabel.textColor = .black
        netIncomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(netIncomeLabel)
        
        oldNumberOfSheetsLabel.text = "原本張數："
        oldNumberOfSheetsLabel.textColor = .black
        oldNumberOfSheetsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oldNumberOfSheetsLabel)
        
        oldNumberOfSheetsTextField.borderStyle = .roundedRect
        oldNumberOfSheetsTextField.placeholder = "輸入張數"
        oldNumberOfSheetsTextField.text = "1"
        oldNumberOfSheetsTextField.keyboardType = UIKeyboardType.namePhonePad
        oldNumberOfSheetsTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oldNumberOfSheetsTextField)
        
        newNumberOfSheetsLabel.text = "買入張數："
        newNumberOfSheetsLabel.textColor = .black
        newNumberOfSheetsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newNumberOfSheetsLabel)
        
        newNumberOfSheetsTextField.borderStyle = .roundedRect
        newNumberOfSheetsTextField.placeholder = "輸入張數"
        newNumberOfSheetsTextField.text = "1"
        newNumberOfSheetsTextField.keyboardType = UIKeyboardType.namePhonePad
        newNumberOfSheetsTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newNumberOfSheetsTextField)
                
        highestRisePercentageLabel.text = "百分比："
        highestRisePercentageLabel.textColor = .black
        highestRisePercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(highestRisePercentageLabel)
        
        highestRisePercentageTextField.borderStyle = .roundedRect
        highestRisePercentageTextField.placeholder = "0.001 ~ 1"
        highestRisePercentageTextField.text = "0"
        highestRisePercentageTextField.keyboardType = UIKeyboardType.namePhonePad
        highestRisePercentageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(highestRisePercentageTextField)
        
        NSLayoutConstraint.activate([
            calculateTypeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            buyContainHandPriceTypeLbale.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            buyPriceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            handPriceDiscountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            profitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            
            calculateTypeTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            calculateTypeTextField.topAnchor.constraint(equalTo: calculateTypeLabel.topAnchor),
            calculateTypeTextField.heightAnchor.constraint(equalTo: calculateTypeLabel.heightAnchor),
            calculateTypeTextField.firstBaselineAnchor.constraint(equalTo: calculateTypeLabel.firstBaselineAnchor),
            
            buyContainHandPriceTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            buyContainHandPriceTextField.topAnchor.constraint(equalTo: buyContainHandPriceTypeLbale.topAnchor),
            buyContainHandPriceTextField.heightAnchor.constraint(equalTo: buyContainHandPriceTypeLbale.heightAnchor),
            buyContainHandPriceTextField.firstBaselineAnchor.constraint(equalTo: buyContainHandPriceTypeLbale.firstBaselineAnchor),

            buyPriceTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            buyPriceTextField.topAnchor.constraint(equalTo: buyPriceLabel.topAnchor),
            buyPriceTextField.heightAnchor.constraint(equalTo: buyPriceLabel.heightAnchor),
            buyPriceTextField.firstBaselineAnchor.constraint(equalTo: buyPriceLabel.firstBaselineAnchor),

            handPriceDiscountTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            handPriceDiscountTextField.topAnchor.constraint(equalTo: handPriceDiscountLabel.topAnchor),
            handPriceDiscountTextField.heightAnchor.constraint(equalTo: handPriceDiscountLabel.heightAnchor),
            handPriceDiscountTextField.firstBaselineAnchor.constraint(equalTo: handPriceDiscountLabel.firstBaselineAnchor),
            
            profitTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            profitTextField.topAnchor.constraint(equalTo: profitLabel.topAnchor),
            profitTextField.heightAnchor.constraint(equalTo: profitLabel.heightAnchor),
            profitTextField.firstBaselineAnchor.constraint(equalTo: profitLabel.firstBaselineAnchor),
            
            calculateButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            lowestPriceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            lowestNetLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 280),
            netIncomePriceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            netIncomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:360),
            
            oldNumberOfSheetsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:400),
            newNumberOfSheetsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:440),
            highestRisePercentageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:480),
            
            oldNumberOfSheetsTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            oldNumberOfSheetsTextField.topAnchor.constraint(equalTo: oldNumberOfSheetsLabel.topAnchor),
            oldNumberOfSheetsTextField.heightAnchor.constraint(equalTo: oldNumberOfSheetsLabel.heightAnchor),
            oldNumberOfSheetsTextField.firstBaselineAnchor.constraint(equalTo: oldNumberOfSheetsLabel.firstBaselineAnchor),
            
            newNumberOfSheetsTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            newNumberOfSheetsTextField.topAnchor.constraint(equalTo: newNumberOfSheetsLabel.topAnchor),
            newNumberOfSheetsTextField.heightAnchor.constraint(equalTo: newNumberOfSheetsLabel.heightAnchor),
            newNumberOfSheetsTextField.firstBaselineAnchor.constraint(equalTo: newNumberOfSheetsLabel.firstBaselineAnchor),

            highestRisePercentageTextField.leadingAnchor.constraint(equalTo: calculateTypeLabel.trailingAnchor, constant: 50),
            highestRisePercentageTextField.topAnchor.constraint(equalTo: highestRisePercentageLabel.topAnchor),
            highestRisePercentageTextField.heightAnchor.constraint(equalTo: highestRisePercentageLabel.heightAnchor),
            highestRisePercentageTextField.firstBaselineAnchor.constraint(equalTo: highestRisePercentageLabel.firstBaselineAnchor),
        ])
        
        self.view = view
    }
}

let vc: MyStockController = MyStockController()
vc.preferredContentSize = CGSize(width: 768, height: 1024)
PlaygroundPage.current.liveView = vc
