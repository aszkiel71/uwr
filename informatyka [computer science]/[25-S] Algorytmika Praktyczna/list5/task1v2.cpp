#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

int height(Node* root) {
    if (root == nullptr) {
        return 0;
    }
    return max(height(root->left), height(root->right)) + 1;
}

int diameter(Node* root) {
    if (root == nullptr) {
        return 0;
    }
    int lheight = height(root->left);
    int rheight = height(root->right);
    int ldiameter = diameter(root->left);
    int rdiameter = diameter(root->right);

    return max(lheight + rheight + 1, max(ldiameter, rdiameter));
}


int main(){
    int N;
    cin>>N;
    pair<int, int> arr[N-1];


    bool flague = true;
    for(int i=0;i<N-1;i++){
        cin >> arr[i].first;
        cin >> arr[i].second;
        if (flague){
          Node *root = new Node(arr[i].first);
          flague = false;
        }
        Node *NewNode = new Node(arr[i].second);
        // nvm
    }

}