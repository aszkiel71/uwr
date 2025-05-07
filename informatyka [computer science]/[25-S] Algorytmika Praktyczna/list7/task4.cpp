#include <iostream>
#define ll long long
using namespace std;
#pragma GCC optimize("Ofast")
#pragma GCC target("avx,bmi,bmi2,lzcnt,popcnt")
void propagate(ll st[], ll lazyAdding[], ll lazySet[], ll node, ll l, ll r) {
    if (lazySet[node] != -1) {
        st[node] = lazySet[node] * (r - l + 1);
        if (l != r) {
            lazySet[2*node + 1] = lazySet[node];    lazySet[2*node + 2] = lazySet[node];
            lazyAdding[2*node + 1] = 0;    lazyAdding[2*node + 2] = 0;
        }
        lazySet[node] = -1;
    }
    if (lazyAdding[node] != 0) {
        st[node] += lazyAdding[node] * (r - l + 1);
        if (l != r) {
            lazyAdding[2*node + 1] += lazyAdding[node];
            lazyAdding[2*node + 2] += lazyAdding[node];
        }
        lazyAdding[node] = 0;
    }
}

void updateAdding(ll st[], ll lazyAdding[], ll lazySet[], ll node, ll l, ll r, ll ql, ll qr, ll v) {
    propagate(st, lazyAdding, lazySet, node, l, r);
    if (l > qr || r < ql)
        return;
    if (ql <= l && r <= qr) {
        lazyAdding[node] += v;
        propagate(st, lazyAdding, lazySet, node, l, r);
        return;
    }
    ll mid = (l + r) / 2;
    updateAdding(st, lazyAdding, lazySet, 2*node + 1, l, mid, ql, qr, v);
    updateAdding(st, lazyAdding, lazySet, 2*node + 2, mid + 1, r, ql, qr, v);
    st[node] = st[2*node + 1] + st[2*node + 2];
}

void updateSet(ll st[], ll lazyAdding[], ll lazySet[], ll node, ll l, ll r, ll ql, ll qr, ll v) {
    propagate(st, lazyAdding, lazySet, node, l, r);
    if (l > qr || r < ql || r < l)
        return;
    if (ql <= l && r <= qr) {
        lazySet[node] = v;      lazyAdding[node] = 0;
        propagate(st, lazyAdding, lazySet, node, l, r);
        return;
    }
    ll mid = (l + r) / 2;
    updateSet(st, lazyAdding, lazySet, 2*node + 1, l, mid, ql, qr, v);
    updateSet(st, lazyAdding, lazySet, 2*node + 2, mid + 1, r, ql, qr, v);
    st[node] = st[2*node + 1] + st[2*node + 2];
}

ll query(ll st[], ll lazyAdd[], ll lazySet[], ll l, ll r, ll ql, ll qr, ll node = 0) {
    propagate(st, lazyAdd, lazySet, node, l, r);
    if (l > qr || r < ql)
        return 0;
    if (ql <= l && r <= qr)
        return st[node];
    ll mid = (l + r) / 2;
    return query(st, lazyAdd, lazySet,  l, mid, ql, qr, 2*node + 1) +
           query(st, lazyAdd, lazySet,  mid + 1, r, ql, qr, 2*node + 2);
}

int main(){
    ios::sync_with_stdio(false);    cout.tie(nullptr);cin.tie(nullptr);

    ll N, Q; cin >> N >> Q; ll arr[N];
    for (ll i = 0; i < N; i++) cin >> arr[i];
    ll ST[4*N + 4], lazyAdding[4*N + 4], lazySet[4*N + 4];
    for (ll i = 0; i < 4*N + 4; i++){  lazyAdding[i] = 0; lazySet[i] = -1; ST[i] = 0;}

    ll S = 1; while (S <= N)  S *= 2; S--;
    ll j = 0;
    for (ll i = S; i < S + N; i++)
            ST[i] = arr[j++];

    for (ll i = S - 1; i >= 0; i--)
        ST[i] = ST[2*i + 1] + ST[2*i + 2];

    while (Q--) {
        ll q;
        cin >> q;
        if (q == 1) {
            ll x, y, v; cin >> x >> y >> v; x--; y--;
            updateAdding(ST, lazyAdding, lazySet, 0, 0, S, x, y, v);
        } else if (q == 2) {
            ll x, y, v; cin >> x >> y >> v; x--; y--;
            updateSet(ST, lazyAdding, lazySet, 0, 0, S, x, y, v);
        } else {
            ll x,y; cin>>x>>y; x--; y--;
            cout << query(ST, lazyAdding, lazySet,  0, S, x, y) << "\n";
        }
    }
    return 0;
}
