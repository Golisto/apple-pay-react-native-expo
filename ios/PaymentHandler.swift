import ExpoModulesCore
import PassKit

struct PaymentRequestItemData: Record {
    @Field
    var label: String
    
    @Field
    var amount: String
}

struct PaymentRequestData: Record {
    @Field
    var merchantIdentifier: String
    
    @Field
    var countryCode: String
    
    @Field
    var currencyCode: String
    
    @Field
    var merchantCapabilities: [String] = ["capability3DS"]
    
    @Field
    var supportedNetworks: [String]
    
    @Field
    var paymentSummaryItems: [PaymentRequestItemData]
}

typealias PaymentCompletionHandler = (PKPaymentAuthorizationResult) -> Void

class PaymentHandler: NSObject  {
    var paymentController: PKPaymentAuthorizationController?
    var promise: Promise!
    var handleCompletion: PaymentCompletionHandler?
    
    public func show(data: PaymentRequestData, promise: Promise) {
        self.promise = promise;
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = data.paymentSummaryItems.map {
            PKPaymentSummaryItem(label: $0.label, amount: NSDecimalNumber(string: $0.amount), type: .final)
        }
        
        paymentRequest.merchantIdentifier = data.merchantIdentifier
        paymentRequest.merchantCapabilities = getMerchantCapabilitiesFromData(jsMerchantCapabilities: data.merchantCapabilities)
        paymentRequest.countryCode = data.countryCode
        paymentRequest.currencyCode = data.currencyCode
        paymentRequest.supportedNetworks = getSupportedNetworksFromData(jsSupportedNetworks: data.supportedNetworks)
        
        //        paymentRequest.shippingType = .delivery
        //        paymentRequest.shippingMethods = shippingMethodCalculator()
        //        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController!.delegate = self
        paymentController!.present(completion: { (presented: Bool) in
            if presented {
            } else {
                self.promise.reject("no_show", "Failed to present")
                self.promise = nil
            }
        })
    }
    
    public func complete(status: PKPaymentAuthorizationStatus) {
        handleCompletion?(PKPaymentAuthorizationResult(status: status, errors: [Error]()))
    }
    
    public func dismiss() {
        paymentController?.dismiss()
    }
    
    private func getMerchantCapabilitiesFromData(jsMerchantCapabilities: [String]) -> PKMerchantCapability {
        var PKMerchantCapabilityMap = [String: PKMerchantCapability]()
        
        PKMerchantCapabilityMap["capability3DS"] = PKMerchantCapability.capability3DS
        PKMerchantCapabilityMap["capabilityCredit"] = PKMerchantCapability.capabilityCredit
        PKMerchantCapabilityMap["capabilityDebit"] = PKMerchantCapability.capabilityDebit
        PKMerchantCapabilityMap["capabilityEMV"] = PKMerchantCapability.capabilityEMV
        
        var merchantCapabilities: PKMerchantCapability = [];
        for jsMerchantCapability in jsMerchantCapabilities {
            if (PKMerchantCapabilityMap[jsMerchantCapability] != nil) {
                merchantCapabilities.insert(PKMerchantCapabilityMap[jsMerchantCapability]!)
            }
        }
        
        return merchantCapabilities;
    }
    
    private func getSupportedNetworksFromData(jsSupportedNetworks: [String]) -> [PKPaymentNetwork] {
        var PKPaymentNetworkMap = [String: PKPaymentNetwork]()
        
        PKPaymentNetworkMap["JCB"] = PKPaymentNetwork.JCB
        PKPaymentNetworkMap["amex"] = PKPaymentNetwork.amex
        PKPaymentNetworkMap["cartesBancaires"] = PKPaymentNetwork.cartesBancaires
        PKPaymentNetworkMap["chinaUnionPay"] = PKPaymentNetwork.chinaUnionPay
        PKPaymentNetworkMap["discover"] = PKPaymentNetwork.discover
        PKPaymentNetworkMap["eftpos"] = PKPaymentNetwork.eftpos
        PKPaymentNetworkMap["electron"] = PKPaymentNetwork.electron
        PKPaymentNetworkMap["elo"] = PKPaymentNetwork.elo
        PKPaymentNetworkMap["idCredit"] = PKPaymentNetwork.idCredit
        PKPaymentNetworkMap["interac"] = PKPaymentNetwork.interac
        PKPaymentNetworkMap["mada"] = PKPaymentNetwork.mada
        PKPaymentNetworkMap["maestro"] = PKPaymentNetwork.maestro
        PKPaymentNetworkMap["masterCard"] = PKPaymentNetwork.masterCard
        PKPaymentNetworkMap["privateLabel"] = PKPaymentNetwork.privateLabel
        PKPaymentNetworkMap["quicPay"] = PKPaymentNetwork.quicPay
        PKPaymentNetworkMap["suica"] = PKPaymentNetwork.suica
        PKPaymentNetworkMap["vPay"] = PKPaymentNetwork.vPay
        PKPaymentNetworkMap["visa"] = PKPaymentNetwork.visa
        
        if #available(iOS 14.0, *) {
            PKPaymentNetworkMap["barcode"] = PKPaymentNetwork.barcode
            PKPaymentNetworkMap["girocard"] = PKPaymentNetwork.girocard
        }
        if #available(iOS 14.5, *) {
            PKPaymentNetworkMap["mir"] = PKPaymentNetwork.mir
        }
        if #available(iOS 15.0, *) {
            PKPaymentNetworkMap["nanaco"] = PKPaymentNetwork.nanaco
            PKPaymentNetworkMap["waon"] = PKPaymentNetwork.waon
        }
        if #available(iOS 15.1, *) {
            PKPaymentNetworkMap["dankort"] = PKPaymentNetwork.dankort
        }
        if #available(iOS 16.0, *) {
            PKPaymentNetworkMap["bancomat"] = PKPaymentNetwork.bancomat
            PKPaymentNetworkMap["bancontact"] = PKPaymentNetwork.bancontact
        }
        if #available(iOS 16.4, *) {
            PKPaymentNetworkMap["postFinance"] = PKPaymentNetwork.postFinance
        }
        
        var supportedNetworks: [PKPaymentNetwork] = [];
        
        for supportedNetwork in jsSupportedNetworks {
            if (PKPaymentNetworkMap[supportedNetwork] != nil) {
                supportedNetworks.append(PKPaymentNetworkMap[supportedNetwork]!)
            }
        }
        
        return supportedNetworks;
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        handleCompletion = completion
        do {
            // payment.token.paymentData is empty on simulator
            var json: [String : Any]? = try JSONSerialization.jsonObject(with: payment.token.paymentData, options: []) as? [String: Any] 
            if let paymentNetwork = payment.token.paymentMethod.network?.rawValue {
                json!["paymentNetwork"] = paymentNetwork
            } else {
                print("Payment network is nil")
            } 
            // Serialize the dictionary back to JSON data
            var updatedData: Data = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // Resolve the promise with the updated JSON data
            let appendedJson = try JSONSerialization.jsonObject(with: updatedData, options: []) 
            promise?.resolve(appendedJson)
            promise = nil
        } catch {
            promise?.reject("payment_data_json", "failed to parse")
            promise = nil
        }
    }
    
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
        promise?.reject("dismiss", "closed")
        promise = nil
    }
}
