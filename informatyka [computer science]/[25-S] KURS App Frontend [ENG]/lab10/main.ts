import { evaluateExpression } from './calculator';

const display = document.getElementById('display') as HTMLInputElement;
const buttons = document.querySelectorAll('button');

buttons.forEach((btn) => {
    const value = btn.getAttribute('data-value');

    if (value) {
        btn.addEventListener('click', () => {
            display.value += value;
        });
    }
});

document.getElementById('clear')?.addEventListener('click', () => {
    display.value = '';
});

document.getElementById('delete')?.addEventListener('click', () => {
    display.value = display.value.slice(0, -1);
});

document.getElementById('equals')?.addEventListener('click', () => {
    try {
        display.value = evaluateExpression(display.value);
    } catch {
        display.value = 'Error';
    }
});
