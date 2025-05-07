#include <iostream>
#include <vector>
#include <climits>
#include <cmath>
#pragma GCC optimize("Ofast")

using namespace std;

struct our_pair {
    int id;
    int h;
};

int queryRMQ(const vector<our_pair>& euler_tour, const vector<vector<int>>& rmq_table, int l, int r) {
    if (l > r) swap(l, r);
    int j = floor(log2(r - l + 1));
    int left_index = rmq_table[l][j];
    int right_index = rmq_table[r - (1 << j) + 1][j];
    if (euler_tour[left_index].h <= euler_tour[right_index].h) {
        return euler_tour[left_index].id;
    } else {
        return euler_tour[right_index].id;
    }
}

void dfs(int u, int v, vector<our_pair> &euler_tour, vector<vector<int>> &tree, int height, vector<int> &depth) {
    depth[u] = height;
    euler_tour.push_back({u, height});
    for (int child : tree[u]) {
        if (child == v) {
            continue;
        }
        dfs(child, u, euler_tour, tree, height + 1, depth);
        euler_tour.push_back({u, height});
    }
}

int logus(int a, int b = 2){
    int res = 0; int tmp = 1;
    while (tmp < a) {tmp *= b; res++;}
    return res;
}

signed main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    int N, Q; cin >> N >> Q;
    vector<vector<int>> tree(N + 1);

    for(int i = 0; i < N-1; i++){
        int u, v; cin >> u >> v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }

    vector<our_pair> euler_tour;
    vector<int> depth(N+1);
    dfs(1, -1337, euler_tour, tree, 0, depth);

    vector<int> occurence(N+1, -1337); int idx = 0;
    for (const auto &pair : euler_tour){
        if (occurence[pair.id] == -1337){
            occurence[pair.id] = idx;
        }
        idx++;
    }

    vector<vector<int>> rmq_table(euler_tour.size(), vector<int>(logus(euler_tour.size())+1));

    for (int i = 0; i < euler_tour.size(); ++i)
        rmq_table[i][0] = i;


    for (int j = 1; j <= logus(euler_tour.size()); ++j) {
        int power_of_2 = 1 << (j - 1);
        for (int i = 0; i + (1 << j) <= euler_tour.size(); ++i) {
            int left = rmq_table[i][j - 1];
            int right = rmq_table[i + power_of_2][j - 1];
            if (euler_tour[left].h <= euler_tour[right].h) {
                rmq_table[i][j] = left;
            } else {
                rmq_table[i][j] = right;
            }
        }
    }

    while (Q--) {
        int u, v; cin >> u >> v;
        if (u == v) {
            cout << 0 << '\n';
            continue;
        }
        int lca = queryRMQ(euler_tour, rmq_table, occurence[u], occurence[v]);
        cout << depth[u] + depth[v] - 2*depth[lca] << '\n';
    }

    return 0;
}
