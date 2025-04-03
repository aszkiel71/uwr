#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int n, maxProfit = 0;
vector<vector<int>> profit;
vector<bool> used;

void polska(int pracownik, int currentProfit) {
    if (pracownik == n) {
        maxProfit = max(maxProfit, currentProfit);
        return;
    }
    for (int job = 0; job < n; job++) {
        if (!used[job]) {
            used[job] = true;
            polska(pracownik + 1, currentProfit + profit[pracownik][job]);
            used[job] = false;
        }
    }
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    cin >> n;
    profit.assign(n, vector<int>(n));
    used.assign(n, false);

    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            cin >> profit[i][j];

    polska(0, 0);
    cout << maxProfit << "\n";

    return 0;
}
