import os
import sys
import itertools

sys.path.append(os.path.join(os.path.dirname(__file__), 'P1'))
from sentence_probability import sentence_prob, device

TOP_K = 10
BOTTOM_K = 3


def normalize_words(words):
    """Rozbija wejście na słowa, ściąga ew. kropkę/interpunkcję i sprowadza
    do małych liter - permutujemy neutralny (multi)zbiór słów, kapitalizacja
    pierwszego słowa jest dodawana osobno dla każdego uszeregowania."""
    return [w.strip('.,!?;:').lower() for w in words if w.strip('.,!?;:')]


def build_sentence(word_perm):
    words = list(word_perm)
    words[0] = words[0].capitalize()
    return ' '.join(words) + '.'


def rank_orderings(words):
    base_words = normalize_words(words)
    seen = set()
    scored = []
    for perm in itertools.permutations(base_words):
        if perm in seen:
            continue
        seen.add(perm)
        sentence = build_sentence(perm)
        score = float(sentence_prob(sentence))
        scored.append((score, sentence))
    scored.sort(key=lambda x: x[0], reverse=True)
    return scored


def print_ranking(words, top_k=TOP_K, bottom_k=BOTTOM_K):
    base_words = normalize_words(words)
    scored = rank_orderings(words)
    print(f"Zbior slow: {{{', '.join(base_words)}}}  "
          f"({len(scored)} unikalnych uszeregowan z {len(base_words)}! mozliwych)")
    print(f"\nNajbardziej naturalne (top {min(top_k, len(scored))}):")
    for score, sentence in scored[:top_k]:
        print(f"  {score:8.4f}  {sentence}")
    if bottom_k and len(scored) > top_k:
        print(f"\nNajmniej naturalne (bottom {min(bottom_k, len(scored))}):")
        for score, sentence in scored[-bottom_k:]:
            print(f"  {score:8.4f}  {sentence}")
    print()


EXAMPLE_SENTENCES = [
    "Babuleńka miała dwa rogate koziołki",
    "Wiewiórki w parku zaczepiają przechodniów",
    "Ala ma kota",
    "Kot i pies i mysz",
    "Marek codziennie pije poranną kawę",
]


if __name__ == '__main__':
    print(f"(urządzenie: {device})\n")
    if len(sys.argv) > 1:
        sentences = [sys.argv[1:]]
    else:
        sentences = [s.split() for s in EXAMPLE_SENTENCES]

    for words in sentences:
        print_ranking(words)
