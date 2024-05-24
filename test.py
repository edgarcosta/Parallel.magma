from os import fork
from sys import exit

def multi_fork(n):
    res = []
    for i in range(1, n + 1):
        if len(res) == i - 1: # only the parent gets inside of this loop
            f = fork()
            if f != 0:
                res.append(f) # parent branch
            else:
                return [], i # child branch
    return res, 0

b, r = multi_fork(10)
print(b, r)
if r != 0:
    exit(0)
