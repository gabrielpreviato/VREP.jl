int test (int a, int* b) {
  *b = *b + 1;
  return a + *b;
}
