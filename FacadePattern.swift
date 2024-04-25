import Foundation

struct Book {
    let title: String
    let author: String
    var isAvailable: Bool
}

class BookInventorySystem {
    private var books: [Book]

    init(books: [Book]) {
        self.books = books
    }

    func searchByTitle(title: String) -> [Book] {
        return books.filter { $0.title.contains(title) }
    }

    func searchByAuthor(author: String) -> [Book] {
        return books.filter { $0.author.contains(author) }
    }

    func checkAvailability(title: String) -> Bool {
        return books.first { $0.title == title && $0.isAvailable } != nil
    }

    func borrowBook(title: String) -> Bool {
        if let index = books.firstIndex(where: { $0.title == title && $0.isAvailable }) {
            books[index].isAvailable = false
            return true
        }
        return false
    }

    func returnBook(title: String) {
        if let index = books.firstIndex(where: { $0.title == title }) {
            books[index].isAvailable = true
        }
    }
}

struct User {
    let name: String
    var borrowedBooks: [Book]
}

class UserManagementSystem {
    private var users: [User]

    init(users: [User]) {
        self.users = users
    }

    func borrowBook(user: User, book: Book) {
        if let index = users.firstIndex(where: { $0.name == user.name }) {
            users[index].borrowedBooks.append(book)
        }
    }

    func returnBook(user: User, book: Book) {
        if let index = users.firstIndex(where: { $0.name == user.name }),
           let bookIndex = users[index].borrowedBooks.firstIndex(where: { $0.title == book.title }) {
            users[index].borrowedBooks.remove(at: bookIndex)
        }
    }
}

class LibraryFacade {
    private let bookInventorySystem: BookInventorySystem
    private let userManagementSystem: UserManagementSystem

    init(bookInventorySystem: BookInventorySystem, userManagementSystem: UserManagementSystem) {
        self.bookInventorySystem = bookInventorySystem
        self.userManagementSystem = userManagementSystem
    }

    func searchBookByTitle(title: String) -> [Book] {
        return bookInventorySystem.searchByTitle(title: title)
    }

    func searchBookByAuthor(author: String) -> [Book] {
        return bookInventorySystem.searchByAuthor(author: author)
    }

    func checkAvailability(title: String) -> Bool {
        return bookInventorySystem.checkAvailability(title: title)
    }

    func borrowBook(user: User, title: String) -> Bool {
        if bookInventorySystem.borrowBook(title: title) {
            let book = Book(title: title, author: "", isAvailable: false)
            userManagementSystem.borrowBook(user: user, book: book)
            return true
        }
        return false
    }

    func returnBook(user: User, title: String) {
        let book = Book(title: title, author: "", isAvailable: true)
        userManagementSystem.returnBook(user: user, book: book)
        bookInventorySystem.returnBook(title: title)
    }
}

func runTestCases() {
    let book1 = Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", isAvailable: true)
    let book2 = Book(title: "To Kill a Mockingbird", author: "Harper Lee", isAvailable: true)
    let book3 = Book(title: "1984", author: "George Orwell", isAvailable: false)

    let books = [book1, book2, book3]

    let bookInventorySystem = BookInventorySystem(books: books)

    let user1 = User(name: "Alice", borrowedBooks: [])
    let user2 = User(name: "Bob", borrowedBooks: [])

    let users = [user1, user2]

    let userManagementSystem = UserManagementSystem(users: users)

    let libraryFacade = LibraryFacade(bookInventorySystem: bookInventorySystem, userManagementSystem: userManagementSystem)

    print("Search for books by title containing 'The':")
    print(libraryFacade.searchBookByTitle(title: "The"))
    print("\nSearch for books by author containing 'Fitzgerald':")
    print(libraryFacade.searchBookByAuthor(author: "Fitzgerald"))

    print("\nCheck availability of '1984':")
    let isAvailable = libraryFacade.checkAvailability(title: "1984")
    print(isAvailable ? "'1984' is available." : "'1984' is not available.")

    print("\nBorrow 'To Kill a Mockingbird' by Alice:")
    let aliceBorrowed = libraryFacade.borrowBook(user: user1, title: "To Kill a Mockingbird")
    print(aliceBorrowed ? "Successfully borrowed by Alice." : "Failed to borrow by Alice.")

    print("\nBorrow '1984' by Bob:")
    let bobBorrowed = libraryFacade.borrowBook(user: user2, title: "1984")
    print(bobBorrowed ? "Successfully borrowed by Bob." : "Failed to borrow by Bob.")

    print("\nReturn 'To Kill a Mockingbird' by Alice:")
    libraryFacade.returnBook(user: user1, title: "To Kill a Mockingbird")
    print("Returned by Alice.")
}

runTestCases()
