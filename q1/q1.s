
.global make_node
.global insert
.global get
.global getAtMost
/*struct Node* make_node(int val) {
    struct Node* node = (struct Node*)malloc(sizeof(struct Node));
    node->val = val;
    node->left = NULL;
    node->right = NULL;
    return node;
}*/
make_node:
    addi sp,sp,-16
    sd x1,8(sp)
    sw x10,4(sp) #valueof int 

    li x10,24 #as malloc(sizeof(node)) here node size=int(4)+padd(4)+left(8)+right(8)=24.
    call malloc

    lw x5,4(sp) #in 4(sp) x10=val stored here x10 no longer val its pointer so stored in stack,
    sw x5,0(x10) #after malloc x10 is a pointer so in pointer=node so node->val =ie 0(x10) we store val.

    #similarly node->left=right=null
    sd x0,8(x10)
    sd x0,16(x10) #here x10 is node independent of stack as stack in sp and node in x10

    ld x1,8(sp)
    addi sp,sp,16#no longer 4(sp) needed so didnt reload it.
    jalr x0,0(x1)


/*Node* insert(Node* root, int val) {
    if (root == NULL)
        return make_node(val);

    if (val < root->val)
        root->left = insert(root->left, val);
    else
        root->right = insert(root->right, val);

    return root;
}*/
insert:
    addi sp, sp, -24
    sd x1, 16(sp) #ret adress.
    sd x10, 8(sp)      # root
    sw x11, 4(sp)      # val  i.e arg stored

    beq x10, x0, now_insert #if root=null

    lw x5, 0(x10)      # root->val here x10=root =node so 0(x10)=val and 8(x10)=left child and 16(x10)=right
    lw x6, 4(sp)      # val load them 


    blt x6, x5, left    
#sd → stores the VALUE inside a register into memory
#ld → loads a VALUE from memory into a register
# right sub tree.
    ld x7, 16(x10)     #root->right
    mv x10, x7     #now x10=root for recurse=root->right. and x11=val we wanna insert .and insert continues.
    mv x11, x6
    call insert

    ld x28, 8(sp) #root for this recursion loaded
    sd x10, 16(x28) #x10=result of rec -new subtree ka root ie (root->right=16(x28)from stack)=x10.
    #but x10=result of insert(root->righht,val) so becomes root->right = insert(root->right, val);
    mv x10, x28 #ret orig root =return root ;
    ld x1, 16(sp)
    addi sp, sp, 24
    ret


#root->right = insert(root->right, val);
#return root;
left:#left sub tree.
    ld x7, 8(x10)      #root->left same as did above.
    mv x10, x7
    mv x11, x6
    call insert

    ld x28, 8(sp)
    sd x10, 8(x28)
    mv x10, x28
    ld x1, 16(sp)
    addi sp, sp, 24
    ret


now_insert:
    lw x10, 4(sp) #val need to be inserted
    call make_node


/*struct Node* get(struct Node* root, int val) {
    if (root == NULL) return NULL;

    if (root->val == val) return root;

    if (val < root->val)
        return get(root->left, val);
    else
        return get(root->right, val);
}*/


get:
   beq x10,x0,not_found

   lw x5,0(x10) #val into x5

   beq x5,x11,found
   blt x11,x5,turn_left

   #right
   ld x10,16(x10) #load right child of node.
   call get
   ret


turn_left:
   ld x10,8(x10) #load left child into x10
   call get 
   ret

not_found:
   mv x10,x0
   ret

found:
   ret

/*int getAtMost(struct Node* root,int val) {
    int best = -1;

    while (root != NULL) {
        if (root->val <= val) {
            best = root->val;
            root = root->right;
        } else {
            root = root->left;
        }
    }
    return best;
}*/


getAtMost:
    li x5, -1

loop:
    beq x11, x0, donee
    lw x6, 0(x11)
    ble x6, x10, leftee
    ld x11, 8(x11)
    j loop

leftee:
    mv x5, x6
    ld x11, 16(x11)
    j loop

donee:
    mv x10, x5
    ret

 