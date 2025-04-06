#include <iostream>
#include <stack>
#include <vector>
#include <string>
#include <cctype> // dla isdigit

using namespace std;

bool isValidRPN(const vector<string>& expression) {
    stack<int> stack;
    const string operators = "+-*/";

    for (const auto& token : expression) {
        if (isdigit(token[0])) {
            stack.push(stoi(token));
        } else if (operators.find(token) != string::npos) {
            if (stack.size() < 2) {
                return false;
            }
            stack.pop();
            stack.pop();
            stack.push(0);
        } else {
            return false;
        }
    }

    return stack.size() == 1;
}

int main() {

    vector<string> expression1 = {"5", "6", "7", "+", "*"};
    vector<string> expression2 = {"5", "6", "+", "*"};
    vector<string> expression3 = {"5", "+", "7"};

    cout << (isValidRPN(expression1) ? "Valid" : "Invalid") << endl;
    cout << (isValidRPN(expression2) ? "Valid" : "Invalid") << endl;
    cout << (isValidRPN(expression3) ? "Valid" : "Invalid") << endl;

    return 0;
}
