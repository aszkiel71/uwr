// task 1

// the function was declared as a const (with an arrow func) so it cannot be used before declaration

//console.log(capitalize("alice"));

function capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
};


// ------------------

// task 2

function capitalizeSentence(sentence) {
    return sentence.split(" ").map(capitalize).join(" ");
};

//console.log(capitalizeSentence("test test test test"));

// --------------------

// task 3

const ids = new Set();

const generateId = () => {
    let id = 0;
    do {
        id++;
    } while (ids.has(id));
    ids.add(id);
    return id;
};

//console.time("generateId");
for (let i = 0; i < 3000; i++) {
    generateId();
}
//console.timeEnd("generateId");

// ----------------------------
// task 4

function compareObjects(obj1, obj2) {
    if (obj1 === obj2) return true;

    if (
        typeof obj1 !== "object" ||
        obj1 === null ||
        typeof obj2 !== "object" ||
        obj2 === null
    ) {
        return false;
    }

    const keys1 = Object.keys(obj1);
    const keys2 = Object.keys(obj2);

    if (keys1.length !== keys2.length) return false;

    for (let key of keys1) {
        if (!keys2.includes(key)) return false;
        if (!compareObjects(obj1[key], obj2[key])) return false;
    }

    return true;
}

const obj1 = {
    name: "Alice",
    age: 25,
    address: {
        city: "Wonderland",
        country: "Fantasy",
    },
};

const obj2 = {
    name: "Alice",
    age: 25,
    address: {
        city: "Wonderland",
        country: "Fantasy",
    },
};

const obj3 = {
    age: 25,
    address: {
        city: "Wonderland",
        country: "Fantasy",
    },
    name: "Alice",
};

const obj4 = {
    name: "Alice",
    age: 25,
    address: {
        city: "Not Wonderland",
        country: "Fantasy",
    },
};

const obj5 = {
    name: "Alice",
};

/*
console.log("Should be True:", compareObjects(obj1, obj2));
console.log("Should be True:", compareObjects(obj1, obj3));
console.log("Should be False:", compareObjects(obj1, obj4));
console.log("Should be True:", compareObjects(obj2, obj3));
console.log("Should be False:", compareObjects(obj2, obj4));
console.log("Should be False:", compareObjects(obj3, obj4));
console.log("Should be False:", compareObjects(obj1, obj5));
console.log("Should be False:", compareObjects(obj5, obj1));

 */

// ----------------------------------------
// task5

let library = [];

const addBookToLibrary = (title, author, pages, isAvailable, ratings) => {
    if (typeof title !== "string" || title.trim() === "") {
        throw new Error("Invalid title");
    }

    if (typeof author !== "string" || author.trim() === "") {
        throw new Error("Invalid author");
    }

    if (typeof pages !== "number" || pages <= 0) {
        throw new Error("Invalid pages");
    }

    if (typeof isAvailable !== "boolean") {
        throw new Error("Invalid isAvailable");
    }


    if (!Array.isArray(ratings)) {
        throw new Error("Invalid ratings");
    }

    for (const rating of ratings) {
        if (typeof rating !== "number" || rating < 0 || rating > 5) {
            throw new Error("Invalid rating value");
        }
    }

    library.push({
        title,
        author,
        pages,
        available: isAvailable,
        ratings,
    });
};

const testCases = [
    { testCase: ["", "Author", 200, true, []], shouldFail: true },
    { testCase: ["Title", "", 200, true, []], shouldFail: true },
    { testCase: ["Title", "Author", -1, true, []], shouldFail: true },
    { testCase: ["Title", "Author", 200, "yes", []], shouldFail: true },
    { testCase: ["Title", "Author", 200, true, [1, 2, 3, 6]], shouldFail: true },
    { testCase: ["Title", "Author", 200, true, [1, 2, 3, "yes"]], shouldFail: true },
    { testCase: ["Title", "Author", 200, true, [1, 2, 3, {}]], shouldFail: true },
    { testCase: ["Title", "Author", 200, true, []], shouldFail: false },
    { testCase: ["Title", "Author", 200, true, [1, 2, 3]], shouldFail: false },
    { testCase: ["Title", "Author", 200, true, [1, 2, 3, 4]], shouldFail: false },
    { testCase: ["Title", "Author", 200, true, [1, 2, 3, 4, 5]], shouldFail: false },
];

function testAddingBooks(testCases) {
    for (const { testCase, shouldFail } of testCases) {
        try {
            addBookToLibrary(...testCase);
            if (shouldFail) {
                console.log("Test failed:", testCase);
            } else {
                console.log("Test passed:", testCase);
            }
        } catch (e) {
            if (shouldFail) {
                console.log("Test passed:", testCase, "| Error:", e.message);
            } else {
                console.log("Test failed:", testCase, "| Error:", e.message);
            }
        }
    }
}

testAddingBooks(testCases);

//------------------------------
// task 7
function addBooksToLibrary(books) {
    for (const args of books) {
        addBookToLibrary(...args);
    }
}

const books = [
    ["Alice in Wonderland", "Lewis Carroll", 200, true, [1, 2, 3]],
    ["1984", "George Orwell", 300, true, [4, 5]],
    ["The Great Gatsby", "F. Scott Fitzgerald", 150, true, [3, 4]],
    ["To Kill a Mockingbird", "Harper Lee", 250, true, [2, 3]],
    ["The Catcher in the Rye", "J.D. Salinger", 200, true, [1, 2]],
    ["The Hobbit", "J.R.R. Tolkien", 300, true, [4, 5]],
    ["Fahrenheit 451", "Ray Bradbury", 200, true, [3, 4]],
    ["Brave New World", "Aldous Huxley", 250, true, [2, 3]],
    ["The Alchemist", "Paulo Coelho", 200, true, [1, 2]],
    ["The Picture of Dorian Gray", "Oscar Wilde", 300, true, [4, 5]],
];

addBooksToLibrary(books);
//console.log(library);
