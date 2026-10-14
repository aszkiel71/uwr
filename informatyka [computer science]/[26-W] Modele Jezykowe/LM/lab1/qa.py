"""Zadanie 4: proste pytania faktograficzne, bez wyszukiwania informacji -
jedyne zrodlo wiedzy to model jezykowy i pytania ze zbioru uczacego
(task4_questions.txt / task4_answers.txt, PolEval 2021).

Pytania sa routowane do 3 grup wg prostych regul (zweryfikowanych na calym
zbiorze uczacym):

1. "yesno"    - pytania zaczynajace sie od "Czy " BEZ drugiego " czy " w dalszej
                czesci zdania (odrozna je od pytan alternatywnych typu
                "Czy X to A czy B?"). Obsluga: model w trybie prawdopodobienstw
                (ta sama metodologia co label_log_prob w Zadaniu 3/sentiment.py) -
                P("Tak."|pytanie) vs P("Nie."|pytanie).
2. "count"    - pytania "Ile .../Ilu ...". Obsluga: czysta heurystyka, zero
                modelu - zawsze odpowiadamy "2" (najczestsza wartosc wsrod
                odpowiedzi do pytan "Ile/Ilu" w zbiorze uczacym).
3. "generate" - cala reszta (pytania o nazwy, osoby, daty, pytania
                alternatywne itp.). Obsluga: model polka, one-shot prompt,
                generowanie greedy, krotka odpowiedz wycinana do pierwszego
                zdania.
"""

import os
import sys
import random
import subprocess
import tempfile

os.environ.setdefault("LM_MODEL", "bigger")

sys.path.append(os.path.join(os.path.dirname(__file__), 'P1'))
from sentence_probability import tokenizer, model, device, log_probs_from_logits

import torch

DATA_DIR = os.path.join(os.path.dirname(__file__), 'P1')
QUESTIONS_PATH = os.path.join(DATA_DIR, 'task4_questions.txt')
ANSWERS_PATH = os.path.join(DATA_DIR, 'task4_answers.txt')
ANSWER_CHECK_SCRIPT = os.path.join(DATA_DIR, 'answer_check_for_task4.py')

ONE_SHOT_EXAMPLE = "Pytanie: Jak nazywa się stolica Francji?\nOdpowiedź: Paryż\n\n"
MAX_NEW_TOKENS = 16


def classify_question(q):
    if q.startswith('Czy ') and ' czy ' not in q[4:]:
        return 'yesno'
    if q.startswith('Ile ') or q.startswith('Ilu '):
        return 'count'
    return 'generate'


def label_log_prob(prefix_text, suffix_text):
    """Metoda B z Zadania 3 (patrz docstring sentiment.py:label_log_prob) -
    P(sufiks | prefiks), usrednione po tokenach sufiksu."""
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


def answer_yesno(question):
    tak = float(label_log_prob(question, " Tak."))
    nie = float(label_log_prob(question, " Nie."))
    return "tak" if tak > nie else "nie"


def answer_count(_question):
    return "2"


def answer_generate(question):
    prompt = ONE_SHOT_EXAMPLE + f"Pytanie: {question}\nOdpowiedź:"
    input_ids = tokenizer(prompt, return_tensors='pt')['input_ids'].to(device)
    with torch.no_grad():
        output_ids = model.generate(
            input_ids,
            max_new_tokens=MAX_NEW_TOKENS,
            do_sample=False,
            pad_token_id=tokenizer.eos_token_id,
            no_repeat_ngram_size=3,
        )
    new_tokens = output_ids[0][input_ids.shape[1]:]
    text = tokenizer.decode(new_tokens, skip_special_tokens=True)
    answer = text.split('\n')[0].strip()
    for end in ('.', '?', '!'):
        idx = answer.find(end)
        if idx != -1:
            answer = answer[:idx]
            break
    return answer.strip().replace('\t', ' ')


ANSWER_FNS = {'yesno': answer_yesno, 'count': answer_count, 'generate': answer_generate}


def load_data():
    with open(QUESTIONS_PATH, encoding='utf-8') as f:
        questions = [line.rstrip('\n') for line in f]
    with open(ANSWERS_PATH, encoding='utf-8') as f:
        answers = [line.rstrip('\n') for line in f]
    return questions, answers


def run_official_check(found, correct):
    with tempfile.TemporaryDirectory() as tmp:
        with open(os.path.join(tmp, 'found_answers.txt'), 'w', encoding='utf-8') as f:
            f.write('\n'.join(found) + '\n')
        with open(os.path.join(tmp, 'correct_answers.txt'), 'w', encoding='utf-8') as f:
            f.write('\n'.join(correct) + '\n')
        result = subprocess.run(
            [sys.executable, ANSWER_CHECK_SCRIPT],
            cwd=tmp, capture_output=True, text=True, check=True,
        )
    last_line = result.stdout.strip().splitlines()[-1]
    return float(last_line.split(':')[-1].strip())


def evaluate(generate_sample_size=120, seed=42):
    questions, answers = load_data()

    groups = {'yesno': [], 'count': [], 'generate': []}
    for i, q in enumerate(questions):
        groups[classify_question(q)].append(i)

    random.seed(seed)
    gen_all = groups['generate']
    gen_sample = random.sample(gen_all, min(generate_sample_size, len(gen_all)))
    eval_indices = {'yesno': groups['yesno'], 'count': groups['count'], 'generate': gen_sample}

    results = {}
    for name, idx_list in eval_indices.items():
        answer_fn = ANSWER_FNS[name]
        found = [answer_fn(questions[i]) for i in idx_list]
        correct = [answers[i] for i in idx_list]
        n = len(idx_list)
        score = run_official_check(found, correct) if n else 0.0
        results[name] = {
            'n_sample': n,
            'n_total': len(groups[name]),
            'correct': score,
            'accuracy': score / n if n else 0.0,
        }
    return results, len(questions)


if __name__ == '__main__':
    gen_n = int(sys.argv[1]) if len(sys.argv) > 1 else 120
    results, total_questions = evaluate(generate_sample_size=gen_n)

    print(f"Model: {os.environ.get('LM_MODEL')} (urządzenie: {device})")
    print(f"Zbior: {total_questions} pytan\n")

    weighted = 0.0
    for name in ('yesno', 'count', 'generate'):
        r = results[name]
        print(f"[{name}] probka {r['n_sample']}/{r['n_total']} w zbiorze, "
              f"accuracy {r['accuracy']:.1%} ({r['correct']:.0f}/{r['n_sample']})")
        weighted += (r['n_total'] / total_questions) * r['accuracy']

    print(f"\nSzacowana ogolna skutecznosc (wazona wg wielkosci grup w calym "
          f"zbiorze): {weighted:.1%}")
