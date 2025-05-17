const express = require('express');
const speakeasy = require('speakeasy');
const qrcode = require('qrcode');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(__dirname));

let tempSecret = null;
let loggedIn = false;


let transfers = [];

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});


app.get('/setup-2fa', (req, res) => {
    tempSecret = speakeasy.generateSecret({ name: "BankApp 2FA" });

    qrcode.toDataURL(tempSecret.otpauth_url, (err, data_url) => {
        res.send(`
      <h1>Skonfiguruj 2FA</h1>
      <p>Zeskanuj ten kod QR w aplikacji Google Authenticator:</p>
      <img src="${data_url}" alt="Kod QR do 2FA"/><br><br>
      <form action="/verify-2fa" method="POST">
        <label>Kod z aplikacji:</label>
        <input type="text" name="token" required />
        <button type="submit">Zweryfikuj</button>
      </form>
    `);
    });
});


app.post('/verify-2fa', (req, res) => {
    const { token } = req.body;
    const verified = speakeasy.totp.verify({
        secret: tempSecret.base32,
        encoding: 'base32',
        token,
        window: 1
    });

    if (verified) {
        loggedIn = true;
        res.send(`
            <h2>✅ Logowanie zakończone sukcesem. Masz dostęp do AmberGold!</h2>
            <a href="/transfer">Zrób przelew</a><br>
            <a href="/admin">Panel administratora</a>
        `);
    } else {
        res.send('<h2>❌ Kod 2FA niepoprawny. Spróbuj ponownie.</h2><a href="/setup-2fa">Powrót</a>');
    }
});


app.post('/make-transfer', (req, res) => {
    const { sender, receiver, amount, title } = req.body;
    const transfer = {
        sender,
        receiver,
        amount,
        title,
        status: 'oczekujący'
    };

    transfers.push(transfer);
    res.send('<h2>Przelew został dodany do listy oczekujących!</h2>');
});


app.get('/admin', (req, res) => {
    if (!loggedIn) {
        res.send('<h2>Musisz być zalogowany, aby uzyskać dostęp do panelu administratora.</h2>');
        return;
    }

    let transferList = '<h2>Oczekujące przelewy</h2><ul>';
    transfers.forEach((transfer, index) => {
        if (transfer.status === 'oczekujący') {
            transferList += `
            <li>
                ${transfer.sender} -> ${transfer.receiver} - ${transfer.amount} PLN
                <br>Tytuł: ${transfer.title}
                <br><a href="/approve-transfer/${index}">Zatwierdź</a>
            </li>
            `;
        }
    });
    transferList += '</ul>';
    res.send(transferList);
});


app.get('/approve-transfer/:id', (req, res) => {
    const transferId = req.params.id;
    if (transfers[transferId]) {
        transfers[transferId].status = 'zatwierdzony';
        res.send('<h2>Przelew zatwierdzony!</h2><a href="/admin">Powrót do listy</a>');
    } else {
        res.send('<h2>Nie znaleziono takiego przelewu!</h2>');
    }
});


app.get('/transfer', (req, res) => {
    if (!loggedIn) {
        res.send('<h2>Musisz być zalogowany, aby wykonać przelew.</h2>');
        return;
    }

    res.send(`
        <h2>Formularz przelewu</h2>
        <form action="/make-transfer" method="POST">
            <label for="sender">Nadawca:</label>
            <input type="text" id="sender" name="sender" required><br><br>
            <label for="receiver">Odbiorca:</label>
            <input type="text" id="receiver" name="receiver" required><br><br>
            <label for="amount">Kwota:</label>
            <input type="number" id="amount" name="amount" required><br><br>
            <label for="title">Tytuł przelewu:</label>
            <input type="text" id="title" name="title" required><br><br>
            <button type="submit">Zrób przelew</button>
        </form>
    `);
});


app.listen(PORT, () => {
    console.log(`Serwer działa na http://localhost:${PORT}`);
});
