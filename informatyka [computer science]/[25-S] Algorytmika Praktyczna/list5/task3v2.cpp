#include <vector>
#include <iostream>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int n;    cin >> n;

    vector<vector<int>> profit(n, vector<int>(n));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            cin >> profit[i][j];
        }
    }

    int tmp = (1 << n) - 1;
    vector<int> dp(1 << n, 0);
    dp[0] = 0;

    for (int mask = 0; mask <= tmp; mask++) {
        int workers_assigned = __builtin_popcount(mask);
        if (workers_assigned >= n) continue;

        for (int job = 0; job < n; job++) {
            if (!(mask & (1 << job))) {
                int new_mask = mask | (1 << job);
                int new_profit = dp[mask] + profit[workers_assigned][job];
                if (new_profit > dp[new_mask]) {
                    dp[new_mask] = new_profit;
                }
            }
        }
    }

    cout << dp[tmp] << endl;

    return 0;
}