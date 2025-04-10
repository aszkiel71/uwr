#include <iostream>
#include <vector>
using namespace std;
#define ll long long
int main() {
    ios_base::sync_with_stdio(false);   cin.tie(nullptr);   cout.tie(nullptr);
    int N;  cin >> N;   int Arr[N]; int maxVal = -1;
    for (int i = 0; i < N; i++) {cin >> Arr[i];  maxVal = max(maxVal, Arr[i]);}
    int S = 1;  while (S <= maxVal) S *= 2; S -= 1;
    int segTree[4*maxVal + 4] = {0};
    ll res = 0;

    for (int i = 0; i < N; i++) {
        int x = Arr[i];
        int idx = S + x;
        int current = idx;
        while (current > 0) {
            int parent = (current - 1) / 2;
            if (current % 2 == 1) {
                res += segTree[parent * 2 + 2];
            }
            current = parent;
        }

        while (idx > 0){
            segTree[idx]++;
            idx = (idx - 1) / 2;
        }

    }

    cout << res << "\n";
    return 0;
}