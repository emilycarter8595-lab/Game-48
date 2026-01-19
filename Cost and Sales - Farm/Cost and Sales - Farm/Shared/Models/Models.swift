import Foundation

enum AnimalType: String, CaseIterable, Codable, Identifiable {
    case cow = "Cow"
    case pig = "Pigs"
    case chicken = "Chicken"
    case sheep = "Sheep"
    case goat = "Goat"
    case turkey = "Turkey"
    case duck = "Duck"
    case horse = "Horse"
    case rabbit = "Rabbit"
    case wool = "Wool"
    case dairy = "Dairy"
    
    var id: String { self.rawValue }
}

enum ProductCategory: String, CaseIterable, Codable, Identifiable {
    case eggs = "Eggs"
    case meat = "Meat"
    case wool = "Wool"
    case dairy = "Dairy"
    case other = "Other"
    
    var id: String { self.rawValue }
}

struct Expense: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    let date: Date
    var name: String
    var amount: Double
    var cost: Double
    var animalType: AnimalType
}

struct Sale: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    let date: Date
    var category: ProductCategory
    var animalType: AnimalType
    var amount: Double
    var cost: Double
    var buyer: String?
    var otherCategoryName: String?
}
