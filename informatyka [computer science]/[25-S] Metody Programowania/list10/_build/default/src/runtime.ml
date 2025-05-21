(* # -*- mode: c; -*- *)

let with_runtime p =
  Printf.sprintf
  {|
#include <stdio.h>

#define STACK_SIZE 10000
#define HEAP_SIZE  1000000
#define ENV_SIZE   1000

int stack[STACK_SIZE];
int stack_ptr = -1; // top-most element on the stack

int heap[HEAP_SIZE];
int heap_ptr = 0; // first free cell

int env[ENV_SIZE];
int env_ptr = -1; // top-most element in env

// heap objects
#define INT  0
#define BOOL 1
#define UNIT 2
#define PAIR 3

void print_heap_obj(int ptr)
{
  switch (heap[ptr-1])
  {
    case INT:
      printf("%%d", heap[ptr]);
      break;
    case BOOL:
      if (heap[ptr])
        printf("true");
      else
        printf("false");
      break;
    case UNIT:
      printf("()");
      break;
    case PAIR:
      printf("(");
      print_heap_obj(heap[ptr]);
      printf(",");
      print_heap_obj(heap[ptr+1]);
      printf(")");
  }
}

int main()
{
%s
  print_heap_obj(stack[0]);
  printf("\n");
  return 0;
}
  |}
  p
