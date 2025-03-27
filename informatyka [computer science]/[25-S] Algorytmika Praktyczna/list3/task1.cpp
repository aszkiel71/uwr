#include <iostream>
#include <vector>
#define ll long long
using namespace std;

struct our_pair {
    vector<int> array;
    ll suma;
};



void switch_values(vector<our_pair> &ARR, int k, int u) {
    int block_size = ARR[0].array.size(); // All blocks have the same size (at least they should XD)
    int block_index = k / block_size;
    int element_index = k % block_size;

    ARR[block_index].suma -= ARR[block_index].array[element_index];
    ARR[block_index].array[element_index] = u;
    ARR[block_index].suma += u;
}

ll sumaa(vector<our_pair> &ARR, int A, int B) {
    int block_size = ARR[0].array.size();
    ll sum = 0;

    int start_block = A / block_size;
    int end_block = B / block_size;

    if (start_block == end_block) {
        for (int i = A % block_size; i <= B % block_size; i++) {
            sum += ARR[start_block].array[i];
        }
    } else {

        for (int i = A % block_size; i < block_size; i++) {
            sum += ARR[start_block].array[i];
        }

        for (int i = start_block + 1; i <= end_block - 1; i++) {
            sum += ARR[i].suma;
        }

        for (int i = 0; i <= B % block_size; i++) {
            sum += ARR[end_block].array[i];
        }
    }
    return sum;
}

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
    vector<our_pair> ARR(block_size);

    for (int i = 0; i < N; i++) {
        int p;
        cin >> p;
        int block_index = i / block_size;
        ARR[block_index].array.push_back(p);
        ARR[block_index].suma += p;
    }

    while (Q--) {
        int t;
        cin >> t;
        if (t == 1) {
            int k, u;
            cin >> k >> u;
            k--;
            switch_values(ARR, k, u);
        } else if (t == 2) {
            int a, b;
            cin >> a >> b;
            a--; b--;
            cout << sumaa(ARR, a, b) << "\n";
        }
    }

    return 0;
}
