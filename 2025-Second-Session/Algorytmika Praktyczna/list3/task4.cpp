#include <iostream>
#include <vector>
#include <map>
using namespace std;


/*
 * Time limit exceeded
 * I should use MO's algorithm then it gonna make it
 */

struct our_pair {
    vector<int> data;
    map<int, int> mapa;
};

int sqrt_r(int n) {
    int i = 1;
    while (i * i < n) {
        i++;
    }
    return i;
}

int main() {

    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;
    cin >> N >> Q;

    int block_size = sqrt_r(N);


    vector<our_pair> niewiem(block_size + 1);


    vector<int> arr(N);
    for (int i = 0; i < N; i++) {
        cin >> arr[i];

        int block_idx = i / block_size;

        niewiem[block_idx].data.push_back(arr[i]);

        niewiem[block_idx].mapa[arr[i]]++;
    }

    while (Q--) {
        int p, k;
        cin >> p >> k;
        p--; k--;

        int start_block = p / block_size;
        int end_block = k / block_size;

        map<int, int> occur;

        if (start_block == end_block) {
            for (int i = p; i <= k; i++) {
                occur[arr[i]]++;
            }
        } else {
            int block_end = (start_block + 1) * block_size - 1;
            for (int i = p; i <= min(block_end, k); i++) {
                occur[arr[i]]++;
            }

            for (int b = start_block + 1; b < end_block; b++) {
                for (auto &pair : niewiem[b].mapa) {
                    occur[pair.first] += pair.second;
                }
            }

            int block_start = end_block * block_size;
            for (int i = block_start; i <= k; i++) {
                occur[arr[i]]++;
            }
        }

        int goodtho = 0;
        for (auto &pair : occur) {
            if (pair.first == pair.second) {
                goodtho++;
            }
        }

        cout << goodtho << "\n";
    }

    return 0;
}