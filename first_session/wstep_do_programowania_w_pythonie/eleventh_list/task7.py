import pygame
import random
import time

size_x = 600
size_y = 600
pygame.init()
screen = pygame.display.set_mode((size_x, size_y))
pygame.display.set_caption('BONUSOWE PUNKTY PLS')

# w rgb kolorki
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)

player_size = 30
player_x, player_y = size_x//2, size_y//2
player_speed = 5
max_speed = 8
min_speed = 1


enemy_size = 30
enemy_speed = 2
enemies = []




def load_max_score():
    with open('max_score.txt', 'r') as f:
        return int(f.read().strip())

def save_max_score(max_score):
    with open("max_score.txt", "w") as f:
        f.write(str(max_score))

max_score = load_max_score()

def spawn_enemy():
    x = random.randint(0, size_x - enemy_size)
    y = random.randint(0, size_y - enemy_size)
    enemies.append([x, y])


def check_collision(player_x, player_y, enemy_x, enemy_y, player_size, enemy_size):
    if(player_x < enemy_x + enemy_size and player_x + player_size > enemy_x and player_y < enemy_y + enemy_size and player_y + player_size > enemy_y):
        return True
    return False

#przelicznik to bedzie (8.5 - player_speed)
score = 0
last_score_update = 0 # kiedy ostatnio aktualizywalismy wynik
score_update_delay = 300 # 0.3 sec


running = True
clock = pygame.time.Clock()
last_spawn_time = pygame.time.get_ticks()
start_time = pygame.time.get_ticks()

while running:
    screen.fill(BLACK)
    current_time = pygame.time.get_ticks()
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # sterowanie postaci za pomoca WSADu
    keys = pygame.key.get_pressed()
    if keys[pygame.K_a]:  # left
        player_x -= player_speed
    if keys[pygame.K_d]:  # right
        player_x += player_speed
    if keys[pygame.K_w]:  # up
        player_y -= player_speed
    if keys[pygame.K_s]:  # down
        player_y += player_speed

    if keys[pygame.K_r] and player_speed < max_speed:
        player_speed *= 1.15
    if keys[pygame.K_e] and player_speed > min_speed:
        player_speed *= 0.75

        player_speed *= 1.1
    # nie dziala ten skill nwm

    # lewa krawedz
    if player_x < 0:
        player_x = 0

    # prawa krawedz
    if player_x > size_x - player_size:
        player_x = size_x - player_size

    # gorna krawedz
    if player_y < 0:
        player_y = 0

   # dolna krawedz
    if player_y > size_y - player_size:
        player_y = size_y - player_size

    # respawn postaci
    current_time = pygame.time.get_ticks()
    # spawnujemy co 6 sekund
    if current_time - last_spawn_time > 6000:
        spawn_enemy()
        last_spawn_time = current_time

    if current_time - last_score_update >= score_update_delay:
        score += int(8.5 - player_speed)
        last_score_update = current_time

    if score > max_score:
        max_score = score
        save_max_score(max_score)

    font = pygame.font.SysFont(None, 55)
    score_text = font.render(f"Score: {score}", True, WHITE)
    screen.blit(score_text, (10, 10))

    max_score_text = font.render(f"Max Score: {max_score}", True, WHITE)
    screen.blit(max_score_text, (size_x - 400, 10))



    # postac
    pygame.draw.rect(screen, WHITE, (player_x, player_y, player_size, player_size))

    # przeciwnicy
    for enemy in enemies:
        pygame.draw.rect(screen, RED, (enemy[0], enemy[1], enemy_size, enemy_size))

        # ustawmy teraz zeby przeciwnik wykonyuwal ruch w nasza strone
        if enemy[0] < player_x:
            enemy[0] += enemy_speed
        elif enemy[0] > player_x:
            enemy[0] -= enemy_speed
        if enemy[1] < player_y:
            enemy[1] += enemy_speed
        elif enemy[1] > player_y:
            enemy[1] -= enemy_speed

        if check_collision(player_x, player_y, enemy[0], enemy[1], player_size, enemy_size):
            font = pygame.font.SysFont(None, 55)
            text = font.render('YOU LOSE!', True, WHITE)
            screen.blit(text, (size_x//2.5, size_y//2.5))
            pygame.display.flip()
            pygame.time.delay(3000) #wait 3 sec to close
            running = False


    pygame.display.flip() #aktualizacja ekranu

    clock.tick(60)

# Zakończenie Pygame
pygame.quit()
