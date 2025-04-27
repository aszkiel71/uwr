#include <iostream>
#include <vector>
#include <climits>
#define elif else if
using namespace std;
#define ll long long
struct pairr {
    int wejscie, wyjscie;
};

void dfs(int u, int p, const vector<vector<int>>& tree, vector<pairr>& prepostORDER, vector<int>& parent, int& time) {
    prepostORDER[u].wejscie = time++;
    parent[u] = p;

    for (int v : tree[u]) {
        if (v != p) {
            dfs(v, u, tree, prepostORDER, parent, time);
        }
    }

    prepostORDER[u].wyjscie = time++;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;
    cin >> N >> Q;
    vector<int> val(N + 1);
    for (int i = 1; i <= N; ++i) cin >> val[i];

    vector<vector<int>> tree(N + 1);

    for (int i = 0; i < N-1; ++i) {
        int u, v;
        cin >> u >> v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }

    vector<pairr> prepostORDER(N + 1);
    vector<int> parent(N + 1);
    int time = 0;

    dfs(1, -1, tree, prepostORDER, parent, time);

    int S = 1;
    while (S < 2*N) S *= 2; S--;

    vector<ll> ST(4*S, 0);

    for (int i = 1; i <= N; ++i) {
        int pos = prepostORDER[i].wejscie;
        ST[S + pos] = val[i];
    }

    for (int i = S - 1; i >= 0; --i) {
        ST[i] = ST[2*i + 1] + ST[2*i + 2];
    }

    while (Q--) {
        int q;
        cin >> q;
        if (q == 1) {
            int v, x;
            cin >> v >> x;
            int pos = prepostORDER[v].wejscie;
            int idx = S + pos;
            ST[idx] = x;
            idx = (idx - 1) / 2;
            while (idx >= 0) {
                ST[idx] = ST[2*idx + 1] + ST[2*idx + 2];
                if (idx == 0) break;
                idx = (idx - 1) / 2;
            }
        } elif (q == 2) {
            ll v;
            cin >> v;
            int l = S + prepostORDER[v].wejscie;
            int r = S + prepostORDER[v].wyjscie;

            ll res = 0;
            while (l <= r) {
                if (l % 2 == 0) {
                    res += ST[l];
                    l++;
                }
                if (r % 2 == 1) {
                    res += ST[r];
                    r--;
                }
                if (l > r) break;
                l = (l - 1) / 2;
                r = (r - 1) / 2;
            }
            cout << res << '\n';
        }
    }

    return 0;
}