# Podatna aplikacja bankowa do testowania SQL Injection
# TYLKO DO CELÓW EDUKACYJNYCH!

from flask import Flask, request, render_template_string, redirect, url_for, session
import sqlite3
import hashlib
import os

app = Flask(__name__)
app.secret_key = 'super_secret_key_123'  # W prawdziwej aplikacji używaj os.urandom(24)


# Inicjalizacja bazy danych
def init_db():
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    # Tabela użytkowników
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            email TEXT,
            balance REAL DEFAULT 1000.0,
            account_number TEXT
        )
    ''')

    # Tabela transakcji
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            type TEXT,
            amount REAL,
            description TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')

    # Dodaj przykładowych użytkowników
    users = [
        ('admin', hashlib.md5('admin123'.encode()).hexdigest(), 'admin@bank.com', 50000.0, 'ACC001'),
        ('jan_kowalski', hashlib.md5('haslo123'.encode()).hexdigest(), 'jan@email.com', 2500.0, 'ACC002'),
        ('anna_nowak', hashlib.md5('qwerty'.encode()).hexdigest(), 'anna@email.com', 1800.0, 'ACC003'),
        ('test_user', hashlib.md5('password'.encode()).hexdigest(), 'test@email.com', 100.0, 'ACC004')
    ]

    for user in users:
        try:
            cursor.execute(
                'INSERT INTO users (username, password, email, balance, account_number) VALUES (?, ?, ?, ?, ?)', user)
        except sqlite3.IntegrityError:
            pass  # User już istnieje

    # Dodaj przykładowe transakcje
    transactions = [
        (2, 'transfer_out', -200.0, 'Przelew do Anna Nowak'),
        (3, 'transfer_in', 200.0, 'Przelew od Jan Kowalski'),
        (2, 'withdrawal', -100.0, 'Wypłata z bankomatu'),
        (1, 'deposit', 5000.0, 'Wpłata gotówki')
    ]

    for trans in transactions:
        try:
            cursor.execute('INSERT INTO transactions (user_id, type, amount, description) VALUES (?, ?, ?, ?)', trans)
        except:
            pass

    conn.commit()
    conn.close()


# PODATNE FUNKCJE - DO EXPLOITOWANIA!

def vulnerable_login(username, password):
    """PODATNA FUNKCJA - bezpośrednie wstawienie do SQL"""
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    # BŁĄD! Podatność na SQL Injection
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{hashlib.md5(password.encode()).hexdigest()}'"
    print(f"[DEBUG] Query: {query}")  # Do debugowania

    try:
        cursor.execute(query)
        result = cursor.fetchone()
        conn.close()
        return result
    except Exception as e:
        print(f"[ERROR] {e}")
        conn.close()
        return None


def vulnerable_get_user_data(user_id):
    """PODATNA FUNKCJA - union-based injection"""
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    # BŁĄD! Podatność na Union-based SQL Injection
    query = f"SELECT username, email, balance, account_number FROM users WHERE id = {user_id}"
    print(f"[DEBUG] Query: {query}")

    try:
        cursor.execute(query)
        result = cursor.fetchone()
        conn.close()
        return result
    except Exception as e:
        print(f"[ERROR] {e}")
        conn.close()
        return None


def vulnerable_search_transactions(user_id, search_term):
    """PODATNA FUNKCJA - blind SQL injection"""
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    # BŁĄD! Podatność na Blind SQL Injection
    query = f"SELECT * FROM transactions WHERE user_id = {user_id} AND description LIKE '%{search_term}%'"
    print(f"[DEBUG] Query: {query}")

    try:
        cursor.execute(query)
        results = cursor.fetchall()
        conn.close()
        return results
    except Exception as e:
        print(f"[ERROR] {e}")
        conn.close()
        return []


# BEZPIECZNE FUNKCJE - PO NAPRAWIENIU

def secure_login(username, password):
    """BEZPIECZNA FUNKCJA - parametryzowane zapytania"""
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    # POPRAWKA! Parametryzowane zapytanie
    query = "SELECT * FROM users WHERE username = ? AND password = ?"
    cursor.execute(query, (username, hashlib.md5(password.encode()).hexdigest()))
    result = cursor.fetchone()
    conn.close()
    return result


def secure_get_user_data(user_id):
    """BEZPIECZNA FUNKCJA"""
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    query = "SELECT username, email, balance, account_number FROM users WHERE id = ?"
    cursor.execute(query, (user_id,))
    result = cursor.fetchone()
    conn.close()
    return result


def secure_search_transactions(user_id, search_term):
    """BEZPIECZNA FUNKCJA"""
    conn = sqlite3.connect('bank.db')
    cursor = conn.cursor()

    query = "SELECT * FROM transactions WHERE user_id = ? AND description LIKE ?"
    cursor.execute(query, (user_id, f'%{search_term}%'))
    results = cursor.fetchall()
    conn.close()
    return results


# GLOBALNA ZMIENNA DO PRZEŁĄCZANIA TRYBÓW
USE_VULNERABLE_CODE = False  # Zmień na False żeby użyć bezpiecznego kodu

# HTML Templates
LOGIN_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>SecureBank - Logowanie</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; background: #f0f0f0; }
        .container { max-width: 400px; margin: auto; background: white; padding: 30px; border-radius: 10px; }
        input { width: 100%; padding: 10px; margin: 10px 0; }
        button { width: 100%; padding: 15px; background: #007bff; color: white; border: none; border-radius: 5px; }
        .error { color: red; margin: 10px 0; }
        .debug { background: #333; color: #0f0; padding: 10px; margin: 10px 0; font-family: monospace; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏦 SecureBank - Logowanie</h2>
        {% if error %}
            <div class="error">{{ error }}</div>
        {% endif %}

        <form method="POST">
            <input type="text" name="username" placeholder="Nazwa użytkownika" required>
            <input type="password" name="password" placeholder="Hasło" required>
            <button type="submit">Zaloguj się</button>
        </form>

        <hr>
        <h4>Testowe konta:</h4>
        <ul>
            <li><strong>admin</strong> / admin123</li>
            <li><strong>jan_kowalski</strong> / haslo123</li>
            <li><strong>anna_nowak</strong> / qwerty</li>
            <li><strong>test_user</strong> / password</li>
        </ul>

        <hr>
        <h4>🚨 Przykładowe ataki SQL Injection:</h4>
        <ul>
            <li><code>admin'--</code> (bypass hasła)</li>
            <li><code>' OR '1'='1'--</code> (login jako pierwszy user)</li>
            <li><code>' UNION SELECT 1,2,3,4,5,6--</code> (union injection)</li>
        </ul>

        <p><small>Tryb: <strong>{{ 'PODATNY' if vulnerable else 'BEZPIECZNY' }}</strong></small></p>
    </div>
</body>
</html>
'''

DASHBOARD_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>SecureBank - Panel</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f0f0f0; }
        .container { max-width: 800px; margin: auto; background: white; padding: 30px; border-radius: 10px; }
        .balance { background: #28a745; color: white; padding: 20px; border-radius: 5px; text-align: center; }
        .section { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        input { padding: 10px; margin: 5px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; }
        .transaction { padding: 10px; border-bottom: 1px solid #eee; }
        .debug { background: #333; color: #0f0; padding: 10px; margin: 10px 0; font-family: monospace; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏦 SecureBank - Panel użytkownika</h2>

        <div class="balance">
            <h3>Saldo: {{ balance }} PLN</h3>
            <p>Konto: {{ account_number }} | {{ username }}</p>
        </div>

        <div class="section">
            <h4>🔍 Wyszukaj transakcje (podatne na SQL Injection)</h4>
            <form method="POST" action="/search">
                <input type="text" name="search" placeholder="Szukaj w opisie transakcji..." value="{{ search_term or '' }}">
                <button type="submit">Szukaj</button>
            </form>

            <p><small>💡 Spróbuj: <code>' OR 1=1--</code> lub <code>' UNION SELECT 1,2,3,4,5,6--</code></small></p>

            {% if transactions %}
                <h5>Wyniki wyszukiwania:</h5>
                {% for trans in transactions %}
                    <div class="transaction">
                        {{ trans[4] }} | {{ trans[2] }}: {{ trans[3] }} PLN - {{ trans[4] }}
                    </div>
                {% endfor %}
            {% endif %}
        </div>

        <div class="section">
            <h4>👤 Informacje o koncie (podatne na Union Injection)</h4>
            <p>URL do testowania: <code>/user?id={{ user_id }}</code></p>
            <p>Spróbuj: <code>/user?id=1 UNION SELECT username,password,email,balance FROM users--</code></p>
        </div>

        <a href="/logout">Wyloguj się</a> | 
        <a href="/toggle">Przełącz tryb ({{ 'PODATNY' if vulnerable else 'BEZPIECZNY' }})</a>
    </div>
</body>
</html>
'''


# Routes
@app.route('/')
def home():
    if 'user_id' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.args.get('username') or request.form['username']
        password = request.args.get('password') or request.form['password']

        if USE_VULNERABLE_CODE:
            user = vulnerable_login(username, password)
        else:
            user = secure_login(username, password)

        if user:
            session['user_id'] = user[0]
            session['username'] = user[1]
            return redirect(url_for('dashboard'))
        else:
            error = "Nieprawidłowe dane logowania"
            return render_template_string(LOGIN_TEMPLATE, error=error, vulnerable=USE_VULNERABLE_CODE)

    return render_template_string(LOGIN_TEMPLATE, vulnerable=USE_VULNERABLE_CODE)


@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']

    if USE_VULNERABLE_CODE:
        user_data = vulnerable_get_user_data(user_id)
    else:
        user_data = secure_get_user_data(user_id)

    if user_data:
        return render_template_string(DASHBOARD_TEMPLATE,
                                      username=user_data[0],
                                      balance=user_data[2],
                                      account_number=user_data[3],
                                      user_id=user_id,
                                      vulnerable=USE_VULNERABLE_CODE)

    return "Błąd pobierania danych użytkownika"


@app.route('/search', methods=['POST'])
def search():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']
    search_term = request.form.get('search', '')

    if USE_VULNERABLE_CODE:
        transactions = vulnerable_search_transactions(user_id, search_term)
        user_data = vulnerable_get_user_data(user_id)
    else:
        transactions = secure_search_transactions(user_id, search_term)
        user_data = secure_get_user_data(user_id)

    return render_template_string(DASHBOARD_TEMPLATE,
                                  username=user_data[0],
                                  balance=user_data[2],
                                  account_number=user_data[3],
                                  user_id=user_id,
                                  transactions=transactions,
                                  search_term=search_term,
                                  vulnerable=USE_VULNERABLE_CODE)


@app.route('/user')
def user_info():
    """Endpoint podatny na Union-based SQL Injection"""
    user_id = request.args.get('id', '1')

    if USE_VULNERABLE_CODE:
        user_data = vulnerable_get_user_data(user_id)
    else:
        user_data = secure_get_user_data(user_id)

    if user_data:
        return f'''
        <h3>Informacje o użytkowniku</h3>
        <p>Nazwa: {user_data[0]}</p>
        <p>Email: {user_data[1]}</p>
        <p>Saldo: {user_data[2]} PLN</p>
        <p>Nr konta: {user_data[3]}</p>
        <hr>
        <a href="/dashboard">Powrót do panelu</a>
        '''

    return "Nie znaleziono użytkownika"


@app.route('/toggle')
def toggle_mode():
    """Przełączanie między trybem podatnym a bezpiecznym"""
    global USE_VULNERABLE_CODE
    USE_VULNERABLE_CODE = not USE_VULNERABLE_CODE
    return redirect(url_for('dashboard'))


@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))


if __name__ == '__main__':
    init_db()
    print("🚨 PODATNA APLIKACJA BANKOWA - TYLKO DO CELÓW EDUKACYJNYCH!")
    print("=" * 60)
    print("Adres: http://localhost:5000")
    print("Testowe konta:")
    print("  admin / admin123")
    print("  jan_kowalski / haslo123")
    print("  anna_nowak / qwerty")
    print("=" * 60)
    print("Przykładowe ataki:")
    print("1. Login bypass: admin'--")
    print("2. Union injection: /user?id=1 UNION SELECT username,password,email,balance FROM users--")
    print("3. Search injection: ' OR 1=1--")
    print("=" * 60)

    app.run(debug=True, host='0.0.0.0', port=5000)