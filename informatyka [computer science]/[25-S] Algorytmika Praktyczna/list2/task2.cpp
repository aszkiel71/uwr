#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

vector<int> color;
vector<vector<int>> tree;
vector<int> result;
vector<unordered_map<int, int>*> mp;

void dfs(int v, int parent) {
    mp[v] = new unordered_map<int, int>();
    (*mp[v])[color[v]] = 1;

    for (int child : tree[v]) {
        if (child == parent) continue;
        dfs(child, v);

        if (mp[child]->size() > mp[v]->size()) swap(mp[v], mp[child]);

        for (auto& [c, count] : *mp[child]) {
            (*mp[v])[c] += count;
        }
    }

    result[v] = mp[v]->size();
}

int main() {
    int n;
    cin >> n;

    color.resize(n + 1);
    tree.resize(n + 1);
    result.resize(n + 1);
    mp.resize(n + 1);

    for (int i = 1; i <= n; i++) cin >> color[i];

    for (int i = 1; i < n; i++) {
        int a, b;
        cin >> a >> b;
        tree[a].push_back(b);
        tree[b].push_back(a);
    }

    dfs(1, -109201329);

    for (int i = 1; i <= n; i++)
        cout << result[i] << " ";

    return 0;
}