#include <iostream>
using namespace std;
#pragma GCC optimize("Ofast")
#pragma GCC target("avx,bmi,bmi2,lzcnt,popcnt")
int find(int ST[], int v, int S, int node = 0){
    if(node >= S) return node;
    if(ST[2*node + 1] >= v) return find(ST, v, S, 2*node + 1);
    else return find(ST, v - ST[2*node + 1], S, 2*node + 2);
}

int main() {
    ios_base::sync_with_stdio(false); cin.tie(nullptr); cout.tie(nullptr);
    int N; cin>>N;
    int S = 1; while(S < N) S *= 2; S--;
    int ST[4*N + 4] = {0};
    int Arr[N]; for(int i = 0; i < N; i++) cin >> Arr[i];
    for(int i = S; i < S + N; i++) ST[i] = 1;
    for(int i = S - 1; i >= 0; i--) ST[i] = ST[2*i + 1] + ST[2*i + 2];
    int Q = N;
    while(Q--){
        int q; cin >> q;
        int idx = find(ST, q, S);
        cout << Arr[idx - S] << ' ';
        ST[idx] = 0;
        int node = idx;
        while(node > 0){
            node = (node - 1)/2;
            ST[node] = ST[2*node + 1] + ST[2*node + 2];
        }
    }
    return 0;
}