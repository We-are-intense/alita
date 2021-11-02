int test(int a, String bb) {
  int b = 5;
  int sum = a + b * 3;
  String ee = "hello world!";
  List dd = [1, 2, 3];
  for (int item in dd) {
    sum += item;
  }

  if(a > 6) {
    b = add(a * 2, b);
  } else {
    b = a + 3;
  }
  return sum;
}

int add(int a, int b) {
  return a + b;
}

