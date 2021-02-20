import Fluent
import FluentPostgresDriver
import Vapor
import Stripe
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func TestRoutes(_ app: Application) throws {
    
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
    
    
    
    
    let tokenProtected = app.grouped(UserToken.authenticator())
    
    app.post("users") { req -> EventLoopFuture<User> in
        try User.Create.validate(req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            username: create.username,
            email: create.email,
            password: Bcrypt.hash(create.password),
            balance: 0
        )
        return user.save(on: req.db)
            .map { user }
    }
    
    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req -> EventLoopFuture<UserToken> in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    //MARK: Authorized Requests
    //TODO: Change to a post with a body

    
    tokenProtected.get("wager") { req -> String in
        do {
            let user = try req.auth.require(User.self)
            
            // Authorization Succeeds
            let _id = UUID(uuidString: "06ee8b76-b041-40fc-8d77-aceff32bc0ec")
            let _contest = UUID(uuidString: "b1e592d7-9742-496f-9c7c-8dbde0f02aa1")
            guard let id = _id else { return "" }
            guard let contest = _contest else { return "" }
            let game = Game.query(on: req.db).filter(\._$id == id).first()
            let _ = game.map { (game) -> (String) in
                let wager = Wager()
                wager.amount = 10
                wager.type = .total
                wager.total = .over
                wager.odds = 115
                wager.$user.id = user.id!
                wager.$game.id = id
                wager.$contest.id = contest
                wager.toWin = wager.calculateWinnings()
                wager.grade = .pending
                let _ = wager.save(on: req.db)
                
                return "Saved Wager"
            }
        }
        catch {
            return Abort(.unauthorized).reason
        }
        return "Running Wager"
    }
}
