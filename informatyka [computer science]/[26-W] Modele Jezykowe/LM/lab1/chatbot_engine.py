import os
import sys
import torch

sys.path.append(os.path.join(os.path.dirname(__file__), 'P1'))
from sentence_probability import sentence_prob, tokenizer, model

MAX_HISTORY = 3
NUM_VARIANTS = 3
MAX_NEW_TOKENS = 25
SPECIALIZATION = os.environ.get("BOT_SPECIALIZATION", "")


def _trim_to_sentence_end(text):
    """Cut off a dangling, mid-clause tail if the text already contains a full sentence."""
    last_end = max(text.rfind('.'), text.rfind('!'), text.rfind('?'))
    if last_end >= 2:
        return text[:last_end + 1]
    return text

class DialogBot:
    def __init__(self, specialization=SPECIALIZATION):
        self.tokenizer = tokenizer
        self.model = model
        self.history = []
        self.specialization = specialization

    def _build_prompt(self, current_user_input):
        if self.specialization:
            role = (
                f"Jesteś Markiem, ekspertem od {self.specialization}. "
                "Twoim zadaniem jest odpowiadać na pytania Tomasza, wykorzystując swoją wiedzę fachową w tej dziedzinie."
            )
        else:
            role = "Jesteś Markiem. Twoim zadaniem jest odpowiadać na pytania Tomasza."

        prompt = (
            f"Instrukcja: {role}\n"
            "Wymagania: Twoje wypowiedzi muszą być bardzo krótkie, zwięzłe i sensowne. "
            "Nie dopisuj i nie powtarzaj wcześniejszych kwestii z historii rozmowy, ponieważ są one automatycznie dodawane przez system.\n"
            "Kontekst: Poniżej znajduje się zapis rozmowy dwóch znajomych, Tomasza i Marka, którzy spotkali się w kawiarni.\n\n"
        )

        for user_msg, bot_msg in self.history:
            prompt += f"- {user_msg} - powiedział Tomasz.\n"
            prompt += f"- {bot_msg} - odparł Marek.\n"

        prompt += f"- {current_user_input} - powiedział Tomasz.\n-"
        return prompt

    def generate_response(self, user_input):
        prompt = self._build_prompt(user_input)

        input_ids = self.tokenizer.encode(prompt, return_tensors='pt').to(self.model.device)

        with torch.no_grad():
            output_ids = self.model.generate(
                input_ids,
                max_new_tokens=MAX_NEW_TOKENS,
                do_sample=True,
                temperature=0.8,
                top_p=0.9,
                num_return_sequences=NUM_VARIANTS,
                pad_token_id=self.tokenizer.eos_token_id,
                no_repeat_ngram_size=3,
                repetition_penalty=1.3,
            )

        best_reply = ""
        best_score = float('-inf')

        for out_seq in output_ids:
            new_tokens = out_seq[input_ids.shape[1]:]
            new_text = self.tokenizer.decode(new_tokens, skip_special_tokens=True)

            reply = new_text.split('\n')[0].split('-')[0].strip()
            reply = _trim_to_sentence_end(reply)

            if len(reply) < 3:
                continue

            score = float(sentence_prob(reply))

            if score > best_score:
                best_score = score
                best_reply = reply

        if not best_reply:
            best_reply = "Rozumiem."

        self.history.append((user_input, best_reply))
        if len(self.history) > MAX_HISTORY:
            self.history.pop(0)

        return best_reply
