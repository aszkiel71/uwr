#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
using namespace std;

struct Query{
    int l, r, idx;
};

int block_size;

bool compare(Query a, Query b){
    int block_a = a.l / block_size;
    int block_b = b.l / block_size;
    if (block_a != block_b)
        return block_a < block_b;
    return a.r < b.r;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;
    cin >> N >> Q;

    block_size = sqrt(N);

    vector<int> arr(N);
    int maxValue = 0;

    for (int i = 0; i < N; i++){
        cin >> arr[i];
        maxValue = max(maxValue, arr[i]);
    }
    maxValue = min(maxValue, N);

    vector<Query> queries(Q);
    vector<int> answers(Q);

    for (int i = 0; i < Q; i++) {
        int p, k;
        cin >> p >> k;
        queries[i] = {p - 1, k - 1, i};
    }

    sort(queries.begin(), queries.end(), compare);
    vector<int> freq(maxValue + 1, 0);

    int goodtho = 0;
    int curr_l = 0, curr_r = -1;

    for (int i = 0; i < Q; i++){
        int l = queries[i].l;
        int r = queries[i].r;
        int idx = queries[i].idx;

        while (curr_l > l){
            curr_l--;
            int val = arr[curr_l];

            if (val <= maxValue) {
                if (freq[val] == val) goodtho--;
                freq[val]++;
                if (freq[val] == val) goodtho++;
            }
        }

        while (curr_r < r){
            curr_r++;
            int val = arr[curr_r];

            if (val <= maxValue) {
                if (freq[val] == val) goodtho--;
                freq[val]++;
                if (freq[val] == val) goodtho++;
            }
        }

        while (curr_l < l){
            int val = arr[curr_l];

            if (val <= maxValue) {
                if (freq[val] == val) goodtho--;
                freq[val]--;
                if (freq[val] == val) goodtho++;
            }

            curr_l++;
        }

        while (curr_r > r){
            int val = arr[curr_r];

            if (val <= maxValue) {
                if (freq[val] == val) goodtho--;
                freq[val]--;
                if (freq[val] == val) goodtho++;
            }

            curr_r--;
        }


        answers[idx] = goodtho;
    }

    for (int i = 0; i < Q; i++){
        cout << answers[i] << "\n";
    }

    return 0;
}