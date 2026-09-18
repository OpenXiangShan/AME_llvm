// Minimal freestanding support for compiler-generated buffer initialization.
// Compile with -fno-builtin so these loops cannot become recursive libc calls.
typedef __SIZE_TYPE__ size_t;

void *memcpy(void *dst, const void *src, size_t count) {
  unsigned char *d = dst;
  const unsigned char *s = src;
  for (size_t i = 0; i < count; ++i)
    d[i] = s[i];
  return dst;
}

void *memset(void *dst, int value, size_t count) {
  unsigned char *d = dst;
  for (size_t i = 0; i < count; ++i)
    d[i] = value;
  return dst;
}
