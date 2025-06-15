#include <unistd.h>

char shellcode[] = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";

int main(int argc, char* argv[])
{
    int *ret;
    ret = (int *)&ret +2;
    (*ret) = (int) shellcode;
}

/* gcc smartnot.c -o smartnot -m32 -fno-stack-protector -z
 * gcc -> kompilator GNU C
 * smartnot.c -> plik zrodlowy do skompilowania
 * -o smartnot -> nazwa pliku wyjsciowego (executable)
 * -m32 kompilacja programu do arhcitektury 32-bitowej
 * (potrzebne bo shellcode zostal napisany dla x86-32)
 * adresy pamieci beda 32-bitowe (4 bajty)
 * instrukcje asemblera beda 32-bitowe
 * bez tego na 64-bitowym systemie shellcode nie zadziala
 *
 * -fno-stack-proector
 * wylacza ochrone stosu
 * kompilator wstawia "canary values" na stos
 * wylaczym go bo
 * ret = (int *)&ret +2; //modyfikacja stosu
 * (*ret) = (int) shellcode; //przypisujemy adres powrotu
 * nasz kod celowo modyfikuje stos, bo gdyby nie to, to stack protector
 * wykrylby to jako atak i program bylby zakonczony
 *
 * -z execstack -> pozwala na wykonywanie kodu ze stosu
 *
*
przygotowanie stringa "/bin/sh":

\x31\xc0              ; xor eax, eax        - wyzeruj eax  (potrzebujemy 0)
\x50                  ; push eax            - umieść 0 na stosie (NULL terminator) (koniec stringa)
\x68\x2f\x2f\x73\x68 ; push 0x68732f2f     - umieść "//sh" na stosie  (buduemym string od tylu)
\x68\x2f\x62\x69\x6e ; push 0x6e69622f     - umieść "/bin" na stosie  (teraz mamy /bin//sh\0

do execve() potrrzebujemy string zakoncozny jako \0

\x89\xe3              ; mov ebx, esp        - ebx wskazuje na "/bin//sh"  wskaznik na stringa

\x50                  ; push eax            - argv[1] = NULL   (koniec tablicy)

\x53                  ; push ebx            - argv[0] = "/bin//sh"  (nazwa programu)

\x89\xe1              ; mov ecx, esp        - ecx wskazuje na argv[] (exc wskazuje na tablice argv)


\xb0\x0b              ; mov al, 11          - numer syscall execve = 11
\xcd\x80              ; int 0x80            - wywołaj execve()

shell -> progrma ,tkory pozwala ci wpisywac komnde i je wykonywac


intuicyjny przyklad:

zamow_pizze("Margherita", "duża", "mój_adres");

1. Napisz "Margherita" na kartce
2. Napisz "duża" na kartce
3. Napisz "mój_adres" na kartce
4. Połóż kartki w kolejności
5. Zadzwoń pod numer pizzerii (11)
6. Powiedz "mam zamówienie" (int 0x80)

Set-MpPreference -DisableRealtimeMonitoring $false

 *
 */