import { MerchantCapability, PaymentNetwork, CompleteStatus, PaymentData } from "./ExpoApplePay.types";
import ExpoApplePayModule from "./ExpoApplePayModule";

export default {
  show: (data: {
    merchantIdentifier: string;
    countryCode: string;
    currencyCode: string;
    merchantCapabilities: MerchantCapability[];
    supportedNetworks: PaymentNetwork[];
    paymentSummaryItems: {
      label: string;
      amount: number;
    }[];
  }): Promise<PaymentData> => {
    return ExpoApplePayModule.show({
      ...data,
      paymentSummaryItems: data.paymentSummaryItems.map((item) => ({
        label: item.label,
        amount: item.amount.toString(),
      })),
    });
  },

  dismiss: () => {
    ExpoApplePayModule.dismiss();
  },
  complete: (status: CompleteStatus) => {
    ExpoApplePayModule.complete(status);
  },
};

export { MerchantCapability, PaymentNetwork, CompleteStatus };
