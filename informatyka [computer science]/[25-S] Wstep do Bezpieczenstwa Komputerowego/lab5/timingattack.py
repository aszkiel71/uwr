import time
from sympy import randprime, mod_inverse
import random
from scipy.stats import ttest_ind
import math

def GenModulus(nbits):
    p = randprime(2 ** (nbits-1), 2 ** nbits)
    q = randprime(2 ** (nbits-1), 2 ** nbits)
    N = p * q
    return N, p, q

def GenRSA(nbits=12):
    N, p, q = GenModulus(nbits)
    m = (p-1) * (q-1)
    e = 17
    while math.gcd(e, m) != 1:
        e += 2
    d = mod_inverse(e, m)
    return N, e, d, p, q


def rsa_crt_dec(c, p, q, d, N):
    dp = d % (p-1)
    dq = d % (q-1)
    qinv = mod_inverse(q, p)
    m1 = pow(c, dp, p)
    m2 = pow(c, dq, q)
    h = (qinv * (m1 - m2)) % p
    m = m2 + h * q
    return m

def measure_decryption_time(c, p, q, d, N):
    start = time.perf_counter_ns()
    rsa_crt_dec(c, p, q, d, N)
    end = time.perf_counter_ns()
    return end - start

def timing_attack_q(N, e, d, p, q, sample_count=300, t_threshold=2.0):
    q_bin = "{0:b}".format(q)
    bit_length = len(q_bin)
    guessed_bits = "1"
    print(f"Real q: {q_bin}")

    i = 1
    while i < bit_length:
        times_0 = []
        times_1 = []

        for _ in range(sample_count):
            m = random.randint(2, N-2)
            c = pow(m, e, N)


            guess0 = int(guessed_bits + "0" + "0" * (bit_length - i - 1), 2)
            guess1 = int(guessed_bits + "1" + "0" * (bit_length - i - 1), 2)

            t0 = measure_decryption_time(c, p, guess0, d, N)
            t1 = measure_decryption_time(c, p, guess1, d, N)
            times_0.append(t0)
            times_1.append(t1)

        stat, _ = ttest_ind(times_0, times_1, equal_var=False)
        avg_0 = sum(times_0) / len(times_0)
        avg_1 = sum(times_1) / len(times_1)
        gap = abs(avg_1 - avg_0) / max(avg_0, avg_1, 1)

        if abs(stat) < t_threshold:
            print(f"Bit {i}: UNSURE! | | |  t-stat={stat:.2f}, gap={gap:.3f} | repeating measure . . .")
            continue

        guessed_bit = "1" if avg_1 > avg_0 else "0"
        print(f"Bit {i}: gussed={guessed_bit}, real={q_bin[i]}, avg_0={avg_0:.1f}, avg_1={avg_1:.1f}, gap={gap:.3f}, t-stat={stat:.2f}")
        guessed_bits += guessed_bit
        i += 1

    print("\nGuessed q:")
    print(guessed_bits)
    print("Real q:")
    print(q_bin)
    correct = sum(1 for a, b in zip(guessed_bits, q_bin) if a == b)
    print(f"Correct: {correct} / {bit_length}")


if __name__ == "__main__":
    N, e, d, p, q = GenRSA(nbits=12)
    timing_attack_q(N, e, d, p, q, sample_count=300, t_threshold=2.0)