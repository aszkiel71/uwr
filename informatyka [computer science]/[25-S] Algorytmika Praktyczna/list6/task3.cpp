#include <iostream>
#include <climits>
#define ll long long

using namespace std;

ll max(ll a1, ll a2) {
    return (a1 > a2) ? a1 : a2;
}

ll max_st(ll ST[], int node, int start, int end, int l, int r) {
    if (r < start || l > end) return LLONG_MIN;
    if (l <= start && end <= r) return ST[node];

    int mid = (start + end) / 2;
    int left_child = 2 * node + 1;
    int right_child = 2 * node + 2;
    return max(max_st(ST, left_child, start, mid, l, r), max_st(ST, right_child, mid + 1, end, l, r));
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q; cin >> N >> Q;    int S = 1; while (S < N) S *= 2; S--;

    ll Arr[N];
    for (int i = 0; i < N; ++i) {
        cin >> Arr[i];
    }

    ll pref[N];
    pref[0] = Arr[0];
    for (int i = 1; i < N; ++i) {
        pref[i] = pref[i - 1] + Arr[i];
    }

    ll ST[4*S + 4];
    fill(ST, ST + 2 * S, LLONG_MIN);

    for (int i = 0; i < N; ++i) {
        ST[S + i] = pref[i];
    }

    for (int i = S - 1; i >= 0; --i) {
        ST[i] = max(ST[2 * i + 1], ST[2 * i + 2]);
    }

    while (Q--) {
        int q; cin >> q;
        if (q == 1) {
            int k; ll v; cin >> k >> v; k--;
            ll delta = v - Arr[k];
            Arr[k] = v;


            for (int i = k; i < N; ++i) {
                pref[i] += delta;
                ST[S + i] = pref[i];
            }


            for (int j = S + k; j < S + N; ++j) {
                int i = j;
                while (i > 0) {
                    int parent = (i - 1) / 2;
                    ll new_val = max(ST[2 * parent + 1], ST[2 * parent + 2]);
                    if (ST[parent] == new_val) break;
                    ST[parent] = new_val;
                    i = parent;
                }
            }
        }
        else if (q == 2) {
            int x, y; cin >> x >> y; x--; y--;
            ll max_prefix = max_st(ST, 0, 0, S - 1, x, y);
            ll subtract = (x > 0) ? pref[x - 1] : 0;
            cout << max((max_prefix == LLONG_MIN ? 0 : max_prefix - subtract), 0) << '\n';
        }
    }
    return 0;
}