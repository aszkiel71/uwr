#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;


struct Heap{
    int n;
    vector<int> heap;

    void sort() {
        for (int i = n - 1; i >= 1; i--) {
            swap(heap[0], heap[i]); n--;
            move_down(0);
        }
    }

    void build() {
        for (int i = (n / 2) - 1; i >= 0; i--) {
            move_down(i);
        }
    }

    void move_up(int i) {
        while (i > 0) {
            if (heap[i] > heap[(i-1) / 2]) {
                swap(heap[i], heap[(i-1) / 2]);
                i = (i - 1) / 2;
            }
            else break;
        }
    }

    void move_down(int i) {
        while (2*i + 1 < n) {
            int l = 2*i + 1, r = 2*i + 2;
            int b = l;
            if (r < n && heap[r] > heap[l]) {
                b = r;
            }

            if (heap[i] < heap[b]) {
                swap(heap[i], heap[b]);
                i = b;
            }
            else break;
        }
    }

    void insert(int x) {
        heap.push_back(x); n++;
        move_up(n-1);
    }

    int find_max() {
        return heap[0];
    }

    void delete_max() {
        heap[0] = heap[n-1]; n--;
        move_down(0);
        heap.pop_back();
    }

    void change_element(int i, int u) {
        int old = heap[i];
        heap[i] = u;
        if (old < u) {
            move_up(i);
        }
        else {
            move_down(i);
        }
    }

    Heap(vector<int> _tab) : heap(_tab) {
        n = (int) heap.size();
        build();
    }

    void print() {
        for (int x : heap) cout << x << " ";
        cout << "\n";
    }
};




int main(){

}
