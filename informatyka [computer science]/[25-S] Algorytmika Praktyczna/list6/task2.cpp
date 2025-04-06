#include <iostream>

using namespace std;

#define ll long long

void update(ll segTree[], ll x, ll y, ll v, ll start, ll end, ll node = 0) {
    if (start > end || start > y || end < x) return;
    if (start >= x && end <= y) {
        segTree[node] += v;
        return;
    }
    ll mid = (start + end) / 2;
    update(segTree, x, y, v, start, mid, 2*node+1);
    update(segTree, x, y, v, mid+1, end, 2*node+2);
}


ll query(ll segTree[], ll k, ll start, ll end, ll node = 0) {
    if (start == end) {return segTree[node];}
    ll mid = (start + end) / 2;
    if (k <= mid) {return segTree[node] + query(segTree, k, start, mid, 2*node + 1);}
    else {return segTree[node] + query(segTree, k, mid+1, end, 2*node+ 2);}
}




int main() {
    ios_base::sync_with_stdio(false);   cin.tie(nullptr);   cout.tie(nullptr);
    int N; cin >> N;    int Q; cin >> Q;    ll Arr[N];     for(int i=0;i<N;i++) cin >> Arr[i];
    ll segTree[4*N + 4] = {0};   int S = 1; while (S < N)    S *= 2;  S--;
    while (Q--){

        int q; cin >> q;
        if (q == 1){
            ll x, y; ll v; cin >> x >> y >> v;   x--; y--;
            update(segTree, x, y, v, 0, N-1);
        }

        else if (q == 2) {
            ll k; cin >> k; k--;
            ll value = Arr[k] + query(segTree, k, 0, N-1);
            cout << value << '\n';
        }
    }
    return 0;
}
