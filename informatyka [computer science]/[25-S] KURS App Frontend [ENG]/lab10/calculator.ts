import { evaluate } from 'mathjs';

export function evaluateExpression(expression: string): string {
    return evaluate(expression).toString();
}
