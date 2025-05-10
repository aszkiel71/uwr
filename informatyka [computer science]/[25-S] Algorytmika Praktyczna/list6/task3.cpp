#include <iostream>
#include <climits>
#define ll long long

using namespace std;

ll max(ll a1, ll a2) {
    return (a1 > a2) ? a1 : a2;
}


ll query(ll ST[], int node, int l, int r, int x, int y) {
    if (x <= l && r <= y)
        return ST[node];
    if (y < l || x > r)
        return 0;

    int mid = (l + r) / 2;
    return query(ST, 2*node + 1, l, mid, x, y) +
           query(ST, 2*node + 2, mid + 1, r, x, y);
}

void update(ll ST[], int node, int l, int r, int pos, ll delta) {
    if (pos < l || pos > r)
        return;
    ST[node] += delta;
    if (l != r) {
        int mid = (l + r) / 2;
        update(ST, 2*node + 1, l, mid, pos, delta);
        update(ST, 2*node + 2, mid + 1, r, pos, delta);
    }
}


void build_pref(ll ST[], int node, int l, int r, ll pref[]) {
    if(l == r) {
        ST[node] = pref[l];
        return;
    }
    int mid = (l + r) / 2;
    build_pref(ST, 2*node + 1, l, mid, pref);
    build_pref(ST, 2*node + 2, mid + 1, r, pref);
    ST[node] = max(ST[2*node + 1], ST[2*node + 2]);
}

void update_range(ll ST[], ll lazy[], int node, int l, int r, int ql, int qr, ll delta) {

    if(lazy[node] != 0) {
        ST[node] += lazy[node];
        if(l != r) {
            lazy[2*node + 1] += lazy[node];
            lazy[2*node + 2] += lazy[node];
        }
        lazy[node] = 0;
    }
    if(qr < l || ql > r)
        return;
    if(ql <= l && r <= qr) {
        ST[node] += delta;
        if(l != r) {
            lazy[2*node + 1] += delta;
            lazy[2*node + 2] += delta;
        }
        return;
    }
    int mid = (l + r) / 2;
    update_range(ST, lazy, 2*node + 1, l, mid, ql, qr, delta);
    update_range(ST, lazy, 2*node + 2, mid + 1, r, ql, qr, delta);
    ST[node] = max(ST[2*node + 1] + lazy[2*node + 1], ST[2*node + 2] + lazy[2*node + 2]);
}

ll query_max(ll ST[], ll lazy[], int node, int l, int r, int ql, int qr) {
    if(lazy[node] != 0) {
        ST[node] += lazy[node];
        if(l != r) {
            lazy[2*node + 1] += lazy[node];
            lazy[2*node + 2] += lazy[node];
        }
        lazy[node] = 0;
    }
    if(qr < l || ql > r)
        return LLONG_MIN;
    if(ql <= l && r <= qr)
        return ST[node];
    int mid = (l + r) / 2;
    ll left = query_max(ST, lazy, 2*node + 1, l, mid, ql, qr);
    ll right = query_max(ST, lazy, 2*node + 2, mid + 1, r, ql, qr);
    return max(left, right);
}


int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;
    cin >> N >> Q;

    ll Arr[N];
    for (int i = 0; i < N; ++i) {
        cin >> Arr[i];
    }

    ll pref[N];
    pref[0] = Arr[0];
    for (int i = 1; i < N; ++i) {
        pref[i] = pref[i - 1] + Arr[i];
    }


    ll ST_pref[4*N];
    ll lazy[4*N] = {0};
    build_pref(ST_pref, 0, 0, N - 1, pref);


    ll ST_changes[4*N] = {0};

    while (Q--) {
        int q;
        cin >> q;
        if (q == 1) {
            int k;ll v;cin >> k >> v;k--;ll delta = v - Arr[k];     Arr[k] = v;
            update(ST_changes, 0, 0, N - 1, k, delta);
            update_range(ST_pref, lazy, 0, 0, N - 1, k, N - 1, delta);
        }
        else if (q == 2) {
            int x, y;   cin >> x >> y;  x--; y--;

            ll max_val = query_max(ST_pref, lazy, 0, 0, N - 1, x, y);
            ll base = (x > 0 ? query_max(ST_pref, lazy, 0, 0, N - 1, x - 1, x - 1) : 0);
            cout << max(max_val - base, 0) << "\n";
        }
    }

    return 0;
}
