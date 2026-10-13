.PHONY: sync t1 t2 t3 t4 help

MODEL ?= papuga
WORDS ?=
N ?= 30
GENN ?= 120
SPEC ?=

help:
	@echo "Usage:"
	@echo "  make sync          - zainstaluj/zsynchronizuj zaleznosci (uv sync)"
	@echo "  make t<N>          - uruchom zadanie N"
	@echo ""
	@echo "Zadanie 1 (chatbot, lab1/chatbot_engine.py + lab1/run_task1.py):"
	@echo "  make t1                 - uruchom chatbota (domyslny model: papuga)"
	@echo "  make t1 MODEL=bigger    - uruchom na wiekszym modelu, do porownania/testow"
	@echo "  make t1 MODEL=<hf/repo> - uruchom na dowolnym innym modelu z Hugging Face"
	@echo "  make t1 SPEC=\"piłka nożna\" - eksperyment: Marek jako ekspert danej dziedziny"
	@echo ""
	@echo "Zadanie 2 (szeregowanie slow, lab1/word_order.py):"
	@echo "  make t2                          - uruchom na przykladach z p1.pdf + kilku wlasnych"
	@echo "  make t2 WORDS=\"kot pies goni\"     - uruchom na wlasnym (multi)zbiorze slow"
	@echo "  make t2 MODEL=bigger WORDS=\"...\"  - jw., z innym modelem"
	@echo ""
	@echo "Zadanie 3 (sentyment opinii, lab1/sentiment.py):"
	@echo "  make t3           - ewaluacja na losowej zbalansowanej probce (domyslnie N=30+30)"
	@echo "  make t3 N=50      - probka 50 GOOD + 50 BAD"
	@echo "  make t3 MODEL=bigger N=50 - jw., z innym modelem"
	@echo ""
	@echo "Zadanie 4 (pytania faktograficzne, lab1/qa.py):"
	@echo "  make t4             - pelne grupy yesno/count + probka GENN=120 z grupy generate"
	@echo "                        (domyslny model dla t4: bigger/polka, zgodnie ze spec.)"
	@echo "  make t4 GENN=50     - mniejsza/wieksza probka dla grupy 'generate'"
	@echo "  make t4 MODEL=papuga - wymus inny model niz domyslny dla t4"
	@echo ""
	@echo "  Dostepne aliasy MODEL (patrz lab1/P1/sentence_probability.py):"
	@echo "    papuga  - flax-community/papuGaPT2  (domyslny dla t1-t3, ~124M)"
	@echo "    bigger  - eryk-mazus/polka-1.1b      (~1.1B, raw/base; domyslny dla t4)"

sync:
	uv sync

t1:
	LM_MODEL=$(MODEL) BOT_SPECIALIZATION="$(SPEC)" uv run --no-sync -q python run_task1.py

t2:
	LM_MODEL=$(MODEL) uv run --no-sync -q python word_order.py $(WORDS)

t3:
	LM_MODEL=$(MODEL) uv run --no-sync -q python sentiment.py $(N)

t4: MODEL = bigger
t4:
	LM_MODEL=$(MODEL) uv run --no-sync -q python qa.py $(GENN)
