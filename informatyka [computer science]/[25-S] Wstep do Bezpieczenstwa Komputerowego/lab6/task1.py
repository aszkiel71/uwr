import random
import itertools
from collections import defaultdict


class ThreeBallotSystem:
    def __init__(self, num_voters, candidates):
        self.num_voters = num_voters
        self.candidates = candidates
        self.num_candidates = len(candidates)

    def generate_vote_for_candidate(self, preferred_candidate):
        """
        Generuje głos dla konkretnego kandydata według zasad ThreeBallot:
        - Preferowany kandydat: 2 zaznaczenia z 3 możliwych
        - Pozostali kandydaci: 1 zaznaczenie z 3 możliwych
        """
        vote = {}

        for candidate in self.candidates:
            if candidate == preferred_candidate:
                # Preferowany kandydat - wybierz 2 z 3 kolumn
                selected_columns = random.sample([0, 1, 2], 2)
                vote[candidate] = [1 if i in selected_columns else 0 for i in range(3)]
            else:
                # Nie-preferowany kandydat - wybierz 1 z 3 kolumn
                selected_column = random.randint(0, 2)
                vote[candidate] = [1 if i == selected_column else 0 for i in range(3)]

        return vote

    def simulate_election(self, vote_distribution):
        """
        Symuluje wybory z zadanym rozkładem głosów
        vote_distribution: dict {kandydat: liczba_głosów}
        """
        all_votes = []

        for candidate, num_votes in vote_distribution.items():
            for _ in range(num_votes):
                vote = self.generate_vote_for_candidate(candidate)
                all_votes.append(vote)

        return all_votes

    def publish_results(self, all_votes):
        """
        Publikuje zagregowane wyniki (symuluje to, co jest publicznie dostępne)
        """
        published_results = defaultdict(lambda: [0, 0, 0])

        for vote in all_votes:
            for candidate in self.candidates:
                for col in range(3):
                    published_results[candidate][col] += vote[candidate][col]

        return dict(published_results)

    def generate_all_possible_votes(self):
        """
        Generuje wszystkie możliwe kombinacje głosów dla jednego wyborcy
        """
        possible_votes = []

        # Dla każdego kandydata jako preferowany
        for preferred in self.candidates:
            # Wszystkie możliwe kombinacje dla preferowanego kandydata (2 z 3)
            pref_combinations = list(itertools.combinations([0, 1, 2], 2))

            for pref_combo in pref_combinations:
                vote = {}
                # Preferowany kandydat
                vote[preferred] = [1 if i in pref_combo else 0 for i in range(3)]

                # Dla pozostałych kandydatów - generuj wszystkie kombinacje (1 z 3)
                other_candidates = [c for c in self.candidates if c != preferred]
                other_combinations = list(itertools.product([0, 1, 2], repeat=len(other_candidates)))

                for other_combo in other_combinations:
                    full_vote = vote.copy()
                    for i, candidate in enumerate(other_candidates):
                        selected_col = other_combo[i]
                        full_vote[candidate] = [1 if j == selected_col else 0 for j in range(3)]

                    possible_votes.append((preferred, full_vote))

        return possible_votes

    def attempt_deanonymization(self, published_results):
        """
        Próbuje odtworzyć oryginalne głosy na podstawie opublikowanych wyników
        """
        print("=== ANALIZA DEANONIMIZACJI ===")
        print(f"Opublikowane wyniki:")
        for candidate, columns in published_results.items():
            print(f"{candidate}: {columns}")

        # Sprawdź czy można wywnioskować wzorce
        total_votes = sum(published_results[list(self.candidates)[0]])
        print(f"\nLączna liczba głosów: {total_votes}")

        # Analiza rozkładu głosów
        print("\nAnaliza rozkładu głosów:")
        for candidate, columns in published_results.items():
            total_marks = sum(columns)
            print(f"{candidate}: {total_marks} zaznaczenia łącznie")

            # Jeśli kandydat ma więcej niż total_votes zaznaczenia, to otrzymał głosy
            if total_marks > total_votes:
                estimated_votes = total_marks - total_votes
                print(f"  -> Szacowana liczba głosów na {candidate}: {estimated_votes}")

        return self.advanced_deanonymization(published_results, total_votes)

    def advanced_deanonymization(self, published_results, total_votes):
        """
        Zaawansowana próba deanonimizacji przez sprawdzenie wszystkich możliwych kombinacji
        """
        print("\n=== ZAAWANSOWANA DEANONIMIZACJA ===")

        possible_votes = self.generate_all_possible_votes()
        print(f"Możliwe wzorce głosów: {len(possible_votes)}")

        # Próba odtworzenia przez brute force dla małych liczb wyborców
        if total_votes <= 5:  # Ograniczenie ze względu na złożoność obliczeniową
            print("Próba pełnej rekonstrukcji...")
            return self.brute_force_reconstruction(published_results, possible_votes, total_votes)
        else:
            print("Zbyt dużo głosów dla pełnej rekonstrukcji - analiza statystyczna...")
            return self.statistical_analysis(published_results, total_votes)

    def brute_force_reconstruction(self, published_results, possible_votes, total_votes):
        """
        Próba odtworzenia wszystkich możliwych kombinacji głosów
        """
        print("Sprawdzanie kombinacji głosów...")
        valid_combinations = []

        # Generuj wszystkie kombinacje głosów
        for combination in itertools.combinations_with_replacement(possible_votes, total_votes):
            # Sprawdź czy ta kombinacja daje opublikowane wyniki
            test_results = defaultdict(lambda: [0, 0, 0])

            for preferred, vote in combination:
                for candidate in self.candidates:
                    for col in range(3):
                        test_results[candidate][col] += vote[candidate][col]

            # Porównaj z rzeczywistymi wynikami
            if dict(test_results) == published_results:
                valid_combinations.append(combination)

        print(f"Znaleziono {len(valid_combinations)} możliwych kombinacji:")
        for i, combo in enumerate(valid_combinations[:5]):  # Pokaż pierwsze 5
            print(f"  Kombinacja {i + 1}: {[pref for pref, _ in combo]}")

        return valid_combinations

    def statistical_analysis(self, published_results, total_votes):
        """
        Analiza statystyczna dla większych zbiorów danych
        """
        print("Analiza wzorców statystycznych...")

        patterns = {}
        for candidate, columns in published_results.items():
            total_marks = sum(columns)
            if total_marks > total_votes:
                # Ten kandydat prawdopodobnie otrzymał głosy
                estimated_votes = total_marks - total_votes
                patterns[candidate] = {
                    'estimated_votes': estimated_votes,
                    'column_distribution': columns,
                    'voting_probability': estimated_votes / total_votes if total_votes > 0 else 0
                }

        return patterns


# Demonstracja działania
def demonstrate_threeballot():
    print("=== DEMONSTRACJA SYSTEMU THREEBALLOT ===\n")

    # Parametry początkowe
    candidates = ['Alice', 'Bob', 'Charlie']
    num_voters = 4

    # Rozkład głosów
    vote_distribution = {
        'Alice': 2,
        'Bob': 1,
        'Charlie': 1
    }

    print(f"Kandydaci: {candidates}")
    print(f"Liczba wyborców: {num_voters}")
    print(f"Rzeczywisty rozkład głosów: {vote_distribution}\n")

    # Stwórz system i przeprowadź symulację
    system = ThreeBallotSystem(num_voters, candidates)

    print("1. Generowanie głosów...")
    all_votes = system.simulate_election(vote_distribution)

    print("2. Publikacja zagregowanych wyników...")
    published_results = system.publish_results(all_votes)

    print("3. Próba deanonimizacji...")
    reconstructed = system.attempt_deanonymization(published_results)

    return system, published_results, reconstructed


def analyze_scv_system():
    """
    Analiza systemu SCV (4 kolumny, 3 wybrane, 2 każdy)
    """
    print("\n\n=== ANALIZA SYSTEMU SCV (4 kolumny, 3 wybrane, 2 każdy) ===")
    print("Parametry: 4 kolumny, 3 zaznaczenia dla preferowanego, 2 dla pozostałych")
    print("Liczba kandydatów: 20 (duża)")

    # Obliczenia teoretyczne
    num_candidates = 20

    # Dla preferowanego kandydata: C(4,3) = 4 możliwości
    pref_combinations = 4

    # Dla każdego z pozostałych 19 kandydatów: C(4,2) = 6 możliwości
    other_combinations = 6 ** 19

    total_combinations = num_candidates * pref_combinations * other_combinations

    print(f"Możliwe kombinacje głosów:")
    print(f"- Preferowany kandydat: C(4,3) = {pref_combinations}")
    print(f"- Każdy z {num_candidates - 1} innych: C(4,2) = 6")
    print(f"- Łączna liczba możliwych głosów: {num_candidates} × 4 × 6^19 ≈ {total_combinations:.2e}")

    print(f"\nWnioski:")
    print(f"- Znacznie większa przestrzeń możliwych głosów")
    print(f"- Deanonimizacja staje się praktycznie niemożliwa")
    print(f"- Zwiększone bezpieczeństwo prywatności wyborców")


if __name__ == "__main__":
    # Uruchom demonstrację
    system, results, reconstructed = demonstrate_threeballot()

    # Analiza systemu SCV
    analyze_scv_system()