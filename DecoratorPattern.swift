protocol Pizza {
    var price: Double { get }
    func getCost() -> Double
}

class BasePizza: Pizza {
    var price: Double
    
    init() {
        self.price = 5.0
    }
    
    func getCost() -> Double {
        return price
    }
}

class PizzaDecorator: Pizza {
    private var pizza: Pizza
    
    init(pizza: Pizza) {
        self.pizza = pizza
    }
    
    var price: Double {
        return pizza.price
    }
    
    func getCost() -> Double {
        return pizza.getCost()
    }
}

class PepperoniTopping: PizzaDecorator {
    override var price: Double {
        return super.price + 1.5
    }
    
    override func getCost() -> Double {
        return super.getCost() + 1.5
    }
}

class MushroomTopping: PizzaDecorator {
    override var price: Double {
        return super.price + 1.0
    }
    
    override func getCost() -> Double {
        return super.getCost() + 1.0
    }
}

let basePizza = BasePizza()
let pepperoniPizza = PepperoniTopping(pizza: basePizza)
let mushroomPepperoniPizza = MushroomTopping(pizza: pepperoniPizza)

print("Base Pizza Cost: \(basePizza.getCost())")
print("Pizza with Pepperoni Cost: \(pepperoniPizza.getCost())")
print("Pizza with Mushroom and Pepperoni Cost: \(mushroomPepperoniPizza.getCost())")

