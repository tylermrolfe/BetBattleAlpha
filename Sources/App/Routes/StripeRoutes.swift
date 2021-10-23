import Fluent
import FluentPostgresDriver
import Vapor
import Stripe
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func StripeRoutes(_ app: Application) throws {
    app.get("chargecustomer") { req -> String in
        req.stripe.customers.retrieve(customer: "cus_IiRdTUMs53kkjj", expand: ["sources"]).map { (customer) -> (String) in
            let source = customer.defaultSource
            req.stripe.charges.create(amount: 3000, currency: .usd, source: source!).map { (charge) -> (String) in
                req.stripe.paymentIntents.confirm(intent: charge.id)
                return ""
            }
            return ""
        }
        return "Charge Customer"
    }
    
    
    app.get("createaccount") { req -> String in
        req.stripe.connectAccounts.create(type: .custom, country: "US", email: "jedge2314@gmail.com", accountToken: nil, businessProfile: ["url": "https://betbattle.com/jedge23"], businessType: .individual, company: nil, defaultCurrency: .usd, externalAccount: nil, individual: ["first_name": "Joey", "last_name": "Pope", "ssn_last_4": 7484, "email": "tylermrolfe@gmail.com", "gender": "female", "phone": 3862923986, "dob": ["day": 17, "month": 8, "year": 1993], "address": ["city": "Lake City", "country": "US", "line1": "3478 SW State Road 247", "postal_code": 32024, "state": "FL"]], metadata: nil, capabilities: ["transfers": ["requested": true]], settings: ["payouts": ["schedule": ["interval": "manual"], "delay_days": 2]], tosAcceptance: ["date": 1527805347, "ip": "66.184.221.82"])
        
        return "Creating Account"
    }
    
    app.get("customerpayment") { req -> String in
        let cardTokenFuture = req.stripe.tokens.create(card: ["number": 4000056655665556, "exp_month": 1, "exp_year": 2022, "cvc": 314, "currency": "usd"], customer: nil).map { (token) -> (String) in
            req.stripe.paymentMethods.create(type: .card, card: ["token": token.id]).map { (method) -> (String) in
                req.stripe.customers.create(address: nil, balance: 0, coupon: nil, description: nil, email: "michellemrolfe@gmail.com", invoicePrefix: nil, invoiceSettings: nil, nextInvoiceSequence: nil, metadata: nil, name: "Michelle Rolfe", paymentMethod: method.id)
                return ""
            }
            return ""
        }
        return "Customer Payment"
    }
    
    app.get("oneoffpayment") { req -> String in
        let cardTokenFuture = req.stripe.tokens.create(card: ["number": 4000056655665556, "exp_month": 1, "exp_year": 2022, "cvc": 314, "currency": "usd"], customer: nil).map { (token) -> (String) in
                req.stripe.charges.create(amount: 2500, currency: .usd, applicationFeeAmount: nil, capture: nil, customer: nil, description: nil, metadata: nil, onBehalfOf: nil, receiptEmail: nil, shipping: nil, source: token.id, statementDescriptor: nil, statementDescriptorSuffix: nil, transferData: nil, transferGroup: nil, expand: nil).map { (stripeCharge) -> (String) in
                if stripeCharge.status == .succeeded {
                    print(stripeCharge.id)
                }
                return "Foo"
            }
            return "Card Token Fut"
        }
        return "Paying"
    }
    
    
    app.get("createcardforaccount") { req -> String in
        let cardTokenFuture = req.stripe.tokens.create(card: ["number": 4000056655665556, "exp_month": 1, "exp_year": 2022, "cvc": 314, "currency": "usd"], customer: nil).map { (token) -> (String) in
            
            let externalCard = req.stripe.externalAccounts.create(account: "acct_1I6JIgRGnAbgMoux", card: token.id, defaultForCurrency: true, metadata: nil)
            return "Card Token Future"
        }
        
        return "Accessing Stripe"
    }

}
