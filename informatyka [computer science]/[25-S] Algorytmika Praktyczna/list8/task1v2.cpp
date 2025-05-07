#include <iostream>
#include <vector>
using namespace std;
#pragma GCC optimize("Ofast")
struct our_pair {
    int id;
    int h;
};

//time limit exceeded

void dfs(int u, int v, vector<our_pair> &euler_tour, vector<vector<int>> &tree, int height) {
    euler_tour.push_back({u, height});
    for (int child : tree[u]) {
        if (child == v) {
            continue;
        }
        dfs(child, u, euler_tour, tree, height + 1);
        euler_tour.push_back({u, height});
    }
}


signed main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    int N, Q;
    cin >> N >> Q;
    vector<vector<int>> tree(N + 1);

    for(int i = 2; i < N + 1; i++){
        int parent;
        cin >> parent;
        tree[parent].push_back(i);
        tree[i].push_back(parent);
    }
    vector<our_pair> euler_tour;
    dfs(1, -1337, euler_tour, tree, 0);

    vector<int> occurence(N+1, -1337);
    int idx = 0;
    for (const auto &pair : euler_tour){
        if (occurence[pair.id] == -1337){
            occurence[pair.id] = idx;
        }
        idx++;
    }
    while(Q--) {
        int v, k;
        cin >> v >> k;
        if(euler_tour[occurence[v]].h < k) {
            cout << -1 << '\n';
            continue;
        }
        if(euler_tour[occurence[v]].h == k) {
            cout << 1 << '\n';
            continue;
        }
        int fdh = euler_tour[occurence[v]].h - k;
        int left = occurence[v];
        bool found = false;
        for(int i = left; i < euler_tour.size(); i++){
            if(euler_tour[i].h == fdh){
                cout << euler_tour[i].id << '\n';
                found = true;
                break;
            }
        }
        if(!found) cout << -1 << '\n';
    }
    return 0;
}
