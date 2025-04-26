#include <iostream>
#include <vector>
#include <climits>
#define ll long long
using namespace std;

struct pairr { ll wejscie = INT_MAX/2; ll wyjscie = INT_MIN/2; };

void dfs(ll u, ll p, const vector<vector<ll>>& tree, vector<pairr>& prepostORDER, vector<ll>& parent, ll& time) {
    prepostORDER[u].wejscie = time++;
    parent[u] = p;
    for (ll v : tree[u]) {
        if (v != p) { // continue;
            dfs(v, u, tree, prepostORDER, parent, time);
        }
    }
    prepostORDER[u].wyjscie = time++;
}

signed main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    ll N, Q;
    cin >> N >> Q;

    vector<ll> val(N);
    for (ll i = 0; i < N; ++i) cin >> val[i];

    vector<vector<ll>> tree(N);
    for (ll i = 0; i < N - 1; ++i) {
        ll u, v;
        cin >> u >> v;
        u--; v--;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }

    vector<pairr> prepostORDER(N);
    vector<ll> parent(N, -1);
    ll time = 0;
    dfs(0, -1337, tree, prepostORDER, parent, time);

    ll S = 1;  while (S <= N) S *= 2;  S--;

    ll ST[4*N + 4]; for(int i = 0; i < 4*N + 4; ++i) ST[i] = 0;


    for (ll i = 0; i < N; i++)
        ST[S + prepostORDER[i].wejscie] = val[i];


    for (ll i = S - 1; i >= 0; i--)
        ST[i] = ST[2*i + 1] + ST[2*i + 2];


    while (Q--) {
        ll q;  cin >> q;
        if (q == 1) {
            ll v, x; cin >> v >> x; v--;
            val[v] = x;
            ll idx = S + prepostORDER[v].wejscie;
            ST[idx] = x;
            while (idx > 0) {
                idx = (idx - 1) / 2;
                ST[idx] = ST[2*idx + 1] + ST[2*idx + 2];
            }
        }
        else if (q == 2) {
            ll v;    cin >> v;     v--;
            ll ans = 0;
            while (v != -1337) {
                ans += ST[S + prepostORDER[v].wejscie];
                v = parent[v];
            }

            cout << ans << '\n';
        }
    }
    return 0;
}
