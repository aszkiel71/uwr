enum Endpoints {
    ELIXIRS = "Elixirs",
    SPELLS = "Spells"
}

type Elixir = {
    id: string;
    name: string;
    effect: string;
};

type Spell = {
    id: string;
    name: string;
    incantation: string;
};

let elixirs: Elixir[] = [];
let spells: Spell[] = [];

let validOption: string | undefined = undefined;

const gameContainer = document.getElementById("game")!;

async function fetchData<T>(endpoint: Endpoints): Promise<T[]> {
    const response = await fetch(
        `https://wizard-world-api.herokuapp.com/${endpoint}`
    );
    if (!response.ok) {
        throw new Error(`Error fetching data from ${endpoint}`);
    }

    const data = await response.json();
    return data;
}

async function fetchAllData() {
    const [elixirsResponse, spellsResponse] = await Promise.all([
        fetchData<Elixir>(Endpoints.ELIXIRS),
        fetchData<Spell>(Endpoints.SPELLS)
    ]);

    elixirs = elixirsResponse.filter((elixir) => elixir.effect);
    spells = spellsResponse.filter((spell) => spell.incantation);
}

function getRandomElements<T>(array: T[], count: number): T[] {
    const indexes: Set<number> = new Set();

    while (indexes.size < count) {
        const randomIndex = Math.floor(Math.random() * array.length);
        indexes.add(randomIndex);
    }

    return Array.from(indexes).map((index) => array[index]);
}

function generateOptions<T extends { name: string }>(randomElements: T[]) {
    const [rightOption, ...rest] = randomElements;

    const options = [rightOption, ...rest].sort(() =>
        Math.random() > 0.5 ? 1 : -1
    );

    return {
        rightOption,
        options
    };
}

function elixirGame() {
    const { options, rightOption } = generateOptions(
        getRandomElements(elixirs, 3)
    );

    validOption = rightOption.name;

    console.log(`Cheat Mode: Right answer is ${validOption}`);

    renderOptions(
        `Which elixir effect is: "${rightOption.effect}"?`,
        options.map((elixir) => elixir.name)
    );
}

function spellGame() {
    const { options, rightOption } = generateOptions(
        getRandomElements(spells, 3)
    );

    validOption = rightOption.name;

    console.log(`Cheat Mode: Right answer is ${validOption}`);

    renderOptions(
        `Which spell incantation is: "${rightOption.incantation}"?`,
        options.map((spell) => spell.name)
    );
}

function renderOptions(question: string, answers: string[]) {
    const questionElement = document.getElementById("question");

    if (!gameContainer || !questionElement) {
        throw new Error("Game container or question element not found");
    }

    gameContainer.innerHTML = "";
    questionElement.textContent = question;

    answers.forEach((answer) => {
        const option = document.createElement("button");

        option.textContent = answer;

        gameContainer.appendChild(option);
    });
}

gameContainer.addEventListener("click", (event: MouseEvent) => {
    const target = event.target as HTMLElement;

    if (target.tagName === "BUTTON") {
        const selectedOption = target.textContent;

        if (selectedOption === validOption) {
            round();
        } else {
            alert("Wrong answer!");
        }
    }
});

function round() {
    const randomGame = Math.random() > 0.5 ? elixirGame : spellGame;
    randomGame();
}

async function startGame() {
    await fetchAllData();
    round();
}

startGame();
