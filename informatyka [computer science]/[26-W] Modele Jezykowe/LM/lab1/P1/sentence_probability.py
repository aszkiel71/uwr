import os

os.environ.setdefault("HF_HUB_DISABLE_SYMLINKS_WARNING", "1")
os.environ.setdefault("TOKENIZERS_PARALLELISM", "false")

import torch
import transformers
import huggingface_hub
from transformers import AutoTokenizer, AutoModelForCausalLM
from torch.nn import functional as F

transformers.logging.set_verbosity_error()
transformers.utils.logging.disable_progress_bar()
huggingface_hub.utils.logging.set_verbosity_error()

# Model selection: set LM_MODEL to an alias below, or to any other HF repo id
# (raw/base checkpoint, not an instruction-tuned one - see Zadanie 1 w p1.pdf).
MODEL_ALIASES = {
    "papuga": "flax-community/papuGaPT2",       # domyslny, ~124M (GPT-2)
    "bigger": "eryk-mazus/polka-1.1b",           # ~1.1B, baza TinyLlama doucz. na PL (raw, nie -chat)
}
_requested_model = os.environ.get("LM_MODEL", "papuga")
model_name = MODEL_ALIASES.get(_requested_model, _requested_model)

device = 'cuda'
device = 'cpu'

tokenizer = AutoTokenizer.from_pretrained(model_name)
# torch_dtype=float32: some bigger models (e.g. the "bigger" alias) ship
# bfloat16 weights by default, which plain CPU torch/numpy can't handle well.
model = AutoModelForCausalLM.from_pretrained(model_name, torch_dtype=torch.float32).to(device)
model.eval()

def log_probs_from_logits(logits, labels):
    logp = F.log_softmax(logits, dim=-1)
    logp_label = torch.gather(logp, 2, labels.unsqueeze(2)).squeeze(-1)
    return logp_label


def sentence_prob(sentence_txt):
    """Average per-token log-probability of sentence_txt under the model.

    The sentence is scored in the context of a leading BOS token, so even a
    single-token sentence gets a real probability (no more degenerate "sum
    over zero pairs" = 0.0 for one-token replies), and the result is divided
    by the number of tokens so replies of different lengths are comparable.
    """
    # add_special_tokens=False: some tokenizers (e.g. Llama-family, used by
    # the "bigger" alias) prepend their own BOS by default, which would
    # double up with the BOS we add explicitly below.
    token_ids = tokenizer(sentence_txt, add_special_tokens=False)['input_ids']
    if len(token_ids) == 0:
        return float('-inf')

    bos_id = tokenizer.bos_token_id
    if bos_id is None:
        bos_id = tokenizer.eos_token_id
    input_ids = torch.tensor([[bos_id] + token_ids], device=device)

    with torch.no_grad():
        output = model(input_ids=input_ids)
        log_probs = log_probs_from_logits(output.logits[:, :-1, :], input_ids[:, 1:])
        seq_log_probs = torch.sum(log_probs)

    return (seq_log_probs / len(token_ids)).float().cpu().numpy()

if __name__ == '__main__':
    sentences = [
      'To jest zwykłe polskie zdanie.',
      'This is a normal English sentence.',
      'iweryuiiu hrfw3eieur fr'
    ]

    print ()
    for s in sentences:
        print (s, sentence_prob(s))
