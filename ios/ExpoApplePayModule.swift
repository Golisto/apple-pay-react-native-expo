import ExpoModulesCore
import PassKit

enum CompleteStatus : Int, Enumerable {
    case success = 0 // Merchant auth'd (or expects to auth) the transaction successfully.
    case failure = 1 // Merchant failed to auth the transaction.
}

public class ExpoApplePayModule: Module {
    public func definition() -> ModuleDefinition {
        Name("ExpoApplePay")
        
        let paymentHandler = PaymentHandler()
        
        AsyncFunction("show") { (data: PaymentRequestData, promise: Promise) in
            paymentHandler.show(data: data, promise: promise);
        }
        
        Function("dismiss") {
            paymentHandler.dismiss()
        }
        
        Function("complete") { (status: CompleteStatus) in
            paymentHandler.complete(
                status: status == CompleteStatus.success ? PKPaymentAuthorizationStatus.success : PKPaymentAuthorizationStatus.failure
            )
        }
    }
}

