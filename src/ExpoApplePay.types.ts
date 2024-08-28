export enum MerchantCapability {
  "3DS" = "capability3DS",
  "EMV" = "capabilityEMV",
  "Credit" = "capabilityCredit",
  "Debit" = "capabilityDebit",
}

export enum PaymentNetwork {
  "JCB" = "JCB",
  "amex" = "amex",
  "cartesBancaires" = "cartesBancaires",
  "chinaUnionPay" = "chinaUnionPay",
  "discover" = "discover",
  "eftpos" = "eftpos",
  "electron" = "electron",
  "elo" = "elo",
  "idCredit" = "idCredit",
  "interac" = "interac",
  "mada" = "mada",
  "maestro" = "maestro",
  "masterCard" = "masterCard",
  "privateLabel" = "privateLabel",
  "quicPay" = "quicPay",
  "suica" = "suica",
  "vPay" = "vPay",
  "visa" = "visa",
  "barcode" = "barcode",
  "girocard" = "girocard",
  "mir" = "mir",
  "nanaco" = "nanaco",
  "waon" = "waon",
  "dankort" = "dankort",
  "bancomat" = "bancomat",
  "bancontact" = "bancontact",
  "postFinance" = "postFinance",
}

export enum CompleteStatus {
  success = 0, // Merchant auth'd (or expects to auth) the transaction successfully.
  failure = 1, // Merchant failed to auth the transaction.
}

export type PaymentData = {
  data: string;
  header: {
    ephemeralPublicKey: string;
    publicKeyHash: string;
    transactionId: string;
  };
  paymentNetwork: string;
  signature: string;
  version: string;
} 