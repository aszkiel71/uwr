const todoList = document.getElementById("todo-list");
const countDisplay = document.getElementById("count");
const form = document.getElementById("add-todo-form");
const input = form.querySelector("input[name='todo-name']");
const clearButton = document.getElementById("todos-clear");

let todos = [
];


function render() {
    todoList.innerHTML = "";

    todos.forEach((todo, index) => {
        const li = document.createElement("li");
        li.className = "todo__container";
        if (todo.completed) li.classList.add("todo__container--completed");


        const nameDiv = document.createElement("div");
        nameDiv.className = "todo-element todo-name";
        nameDiv.textContent = todo.name;
        li.appendChild(nameDiv);


        const upButton = document.createElement("button");
        upButton.className = "todo-element todo-button move-up";
        upButton.textContent = "↑";
        upButton.addEventListener("click", () => moveUp(index));
        li.appendChild(upButton);


        const downButton = document.createElement("button");
        downButton.className = "todo-element todo-button move-down";
        downButton.textContent = "↓";
        downButton.addEventListener("click", () => moveDown(index));
        li.appendChild(downButton);


        const toggleButton = document.createElement("button");
        toggleButton.className = "todo-element todo-button";
        toggleButton.textContent = todo.completed ? "Revert" : "Done";
        toggleButton.addEventListener("click", () => toggleComplete(index));
        li.appendChild(toggleButton);


        const removeButton = document.createElement("button");
        removeButton.className = "todo-element todo-button";
        removeButton.textContent = "Remove";
        removeButton.addEventListener("click", () => removeTodo(index));
        li.appendChild(removeButton);

        todoList.appendChild(li);
    });


    const remaining = todos.filter((t) => !t.completed).length;
    countDisplay.textContent = remaining;
}


form.addEventListener("submit", (e) => {
    e.preventDefault();
    const value = input.value.trim();
    if (value !== "") {
        todos.push({ name: value, completed: false });
        input.value = "";
        render();
    }
});


function removeTodo(index) {
    todos.splice(index, 1);
    render();
}


function toggleComplete(index) {
    todos[index].completed = !todos[index].completed;
    render();
}


function moveUp(index) {
    if (index > 0) {
        [todos[index - 1], todos[index]] = [todos[index], todos[index - 1]];
        render();
    }
}


function moveDown(index) {
    if (index < todos.length - 1) {
        [todos[index + 1], todos[index]] = [todos[index], todos[index + 1]];
        render();
    }
}


clearButton.addEventListener("click", () => {
    todos = [];
    render();
});


render();
