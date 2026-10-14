"""Zadanie 3: wydzwiek opinii (GOOD/BAD) wylacznie z prawdopodobienstw LM,
bez few-shot. Metoda B: warunkowy log-prob sufiksu-etykiety, P(sufiks | opinia),
liczony wzgledem calego kontekstu opinii (nie score calego zdania)."""

import os
import sys
import random

sys.path.append(os.path.join(os.path.dirname(__file__), 'P1'))
from sentence_probability import tokenizer, model, device, log_probs_from_logits

import torch

DATA_PATH = os.path.join(os.path.dirname(__file__), 'P1', 'reviews_for_task3.txt')

POS_SUFFIX = " To bardzo pozytywna opinia."
NEG_SUFFIX = " To bardzo negatywna opinia."


def label_log_prob(prefix_text, suffix_text):
    """Zwraca sredni log-prob/token sufiksu (etykiety), liczony WARUNKOWO na
    calym prefiksie (opinii) - czyli P(sufiks | prefiks), a nie P(prefiks+sufiks).

    Metodologia (Metoda B z Zadania 3, wybrana zamiast prostszego liczenia
    sentence_prob(opinia + etykieta) z Zadania 1/2 - tzw. Metody A):

    Metoda A oceniałaby caly string "opinia + etykieta" jednym srednim
    log-probem po WSZYSTKICH tokenach. Problem: dla dlugiej opinii sygnal,
    ktory nas naprawde interesuje (czy koncowka "...pozytywna/negatywna
    opinia" jest prawdopodobna), rozmywa sie w srednie wsrod dziesiatek
    tokenow samej opinii, ktore sa identyczne w obu wariantach (pozytywnym
    i negatywnym) i nic nie wnosza do porownania. Metoda B liczy TYLKO
    prawdopodobienstwo tokenow etykiety, warunkowo na calej opinii jako
    kontekscie - to dokladnie to, co chcemy porownac miedzy "pozytywna"
    a "negatywna".

    Jak to jest liczone krok po kroku:
    1. Tokenizujemy prefiks (opinie) i sufiks (etykiete) OSOBNO
       (add_special_tokens=False), a nastepnie laczymy same listy ID-kow
       tokenow (prefix_ids + suffix_ids) zamiast tokenizowac zlaczony
       string na nowo. Powod: tokenizer BPE/SentencePiece moglby po
       zlaczeniu scalic ostatni token opinii z pierwszym tokenem etykiety
       w jeden kawalek (merge na granicy slow), co zepsuloby znajomosc
       dokladnej granicy prefiks/sufiks w ciagu tokenow. Rozdzielna
       tokenizacja gwarantuje czysty, znany punkt podzialu.
    2. Jeden forward pass modelu na calej sekwencji [prefix_ids + suffix_ids].
    3. log_probs_from_logits (ta sama funkcja co w sentence_prob z Zadania 1)
       liczy log P(token_i+1 | token_0..token_i) dla kazdej pozycji i - czyli
       log_probs[i] odpowiada predykcji TOKENU NA POZYCJI i+1 w input_ids.
    4. Chcemy tylko predykcje tokenow sufiksu, ktore siedza na pozycjach
       [len(prefix_ids), len(prefix_ids)+len(suffix_ids)-1] w input_ids.
       Predykcja tokenu na pozycji P (pierwszy token sufiksu) to
       log_probs[P-1] (bo log_probs[i] przewiduje input_ids[i+1]=P przy
       i=P-1). Stad start = len(prefix_ids) - 1, a wycinek
       log_probs[start : start+len(suffix_ids)] to dokladnie log-proby
       wszystkich tokenow sufiksu, kazdy warunkowo na wszystkim przed nim
       (czyli finalny token sufiksu jest warunkowy na calej opinii I
       poprzednich tokenach etykiety).
    5. Usredniamy po liczbie tokenow sufiksu (nie prefiksu!) - tak samo jak
       w sentence_prob z Zadania 1, zeby wynik nie zalezal od dlugosci
       sufiksu przy porownywaniu roznych szablonow etykiet.

    Brak doklejania BOS-a (w odroznieniu od sentence_prob w Zadaniu 1/2):
    tam BOS byl potrzebny, bo zdania bywaly oceniane bez zadnego kontekstu
    (nawet 1-tokenowe, np. "Tak"). Tutaj kontekstem jest zawsze realna,
    niepusta opinia - pierwszy token sufiksu ZAWSZE ma na czym sie oprzec.
    """
    prefix_ids = tokenizer(prefix_text, add_special_tokens=False)['input_ids']
    suffix_ids = tokenizer(suffix_text, add_special_tokens=False)['input_ids']
    if not prefix_ids or not suffix_ids:
        return float('-inf')

    input_ids = torch.tensor([prefix_ids + suffix_ids], device=device)
    with torch.no_grad():
        output = model(input_ids=input_ids)
        log_probs = log_probs_from_logits(output.logits[:, :-1, :], input_ids[:, 1:])

    start = len(prefix_ids) - 1
    suffix_log_probs = log_probs[0, start:start + len(suffix_ids)]
    return (suffix_log_probs.sum() / len(suffix_ids)).float().cpu().numpy()


def classify(review_text):
    pos_score = float(label_log_prob(review_text, POS_SUFFIX))
    neg_score = float(label_log_prob(review_text, NEG_SUFFIX))
    return ('GOOD' if pos_score > neg_score else 'BAD'), pos_score, neg_score


def load_reviews(path):
    reviews = []
    with open(path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\n')
            if not line.strip():
                continue
            label, text = line.split(' ', 1)
            reviews.append((label, text))
    return reviews


def sample_balanced(reviews, n_per_class, seed=42):
    random.seed(seed)
    good = [r for r in reviews if r[0] == 'GOOD']
    bad = [r for r in reviews if r[0] == 'BAD']
    return random.sample(good, n_per_class) + random.sample(bad, n_per_class)


def evaluate(n_per_class=30):
    reviews = load_reviews(DATA_PATH)
    sample = sample_balanced(reviews, n_per_class)

    correct = 0
    confusion = {'GOOD': {'GOOD': 0, 'BAD': 0}, 'BAD': {'GOOD': 0, 'BAD': 0}}
    mistakes = []

    for gold, text in sample:
        pred, pos_s, neg_s = classify(text)
        confusion[gold][pred] += 1
        if pred == gold:
            correct += 1
        else:
            mistakes.append((gold, pred, pos_s, neg_s, text))

    accuracy = correct / len(sample)
    return accuracy, confusion, mistakes, len(sample)


if __name__ == '__main__':
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 30
    accuracy, confusion, mistakes, total = evaluate(n)

    print(f"Model: {os.environ.get('LM_MODEL', 'papuga')} (urządzenie: {device})")
    print(f"Probka: {total} opinii ({n} GOOD + {n} BAD)")
    print(f"Accuracy: {accuracy:.1%} ({int(accuracy * total)}/{total})\n")

    print("Macierz pomylek (wiersz=gold, kolumna=predykcja):")
    print(f"              pred GOOD   pred BAD")
    print(f"  gold GOOD   {confusion['GOOD']['GOOD']:>9}   {confusion['GOOD']['BAD']:>8}")
    print(f"  gold BAD    {confusion['BAD']['GOOD']:>9}   {confusion['BAD']['BAD']:>8}")

    if mistakes:
        print(f"\nPrzyklady pomylek ({len(mistakes)}):")
        for gold, pred, pos_s, neg_s, text in mistakes[:10]:
            print(f"  [{gold}->{pred}] pos={pos_s:.3f} neg={neg_s:.3f}  {text[:90]}")
